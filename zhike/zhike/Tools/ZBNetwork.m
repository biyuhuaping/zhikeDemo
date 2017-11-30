//
//  ZBNetwork.m
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBNetwork.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

#define TIMEOUT 30.f //请求超时时间
static AFNetworkReachabilityStatus networkReachabilityStatus;
static NSMutableArray *requestTasksPool;

@implementation NSURLRequest (decide)
//判断是否是同一个请求（依据是请求url和参数是否相同）
- (BOOL)isTheSameRequest:(NSURLRequest *)request {
    if ([self.HTTPMethod isEqualToString:request.HTTPMethod]) {
        if ([self.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
            if ([self.HTTPMethod isEqualToString:@"GET"] || [self.HTTPBody isEqualToData:request.HTTPBody]) {
                DBLOG(@"同一个请求还没执行完，又来请求☹️");
                return YES;
            }
        }
    }
    return NO;
}
@end


@interface ZBNetwork ()
@property (copy, nonatomic) AFHTTPSessionManager *manager;
//@property (strong, nonatomic) NSMutableArray *requestTasksPool;
@end

@implementation ZBNetwork

+ (void)load{
    [self checkNetworkStatus];//开始监听网络
}

+ (instancetype)shaerdInstance{
    static ZBNetwork *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

//开始监听网络
+ (void)checkNetworkStatus {
    // 检测网络连接的单例,网络变化时的回调方法
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DBLOG(@"网络状态是：%@", @(status));
        networkReachabilityStatus = status;
    }];
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) {
            requestTasksPool = [NSMutableArray array];
        }
    });
    return requestTasksPool;
}

- (AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        //默认解析模式
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _manager.requestSerializer.timeoutInterval = TIMEOUT;
        
        //配置响应序列化
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
    }
    
    return _manager;
}

+ (AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
    
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[YQCacheManager shareManager] setCacheTime: diskCapacity:]设置
    return manager;
}

#pragma mark - get
- (ZBURLSessionTask *)getWithUrl:(NSString *)url hud:(BOOL)hud parameters:(NSDictionary *)params progressBlock:(ZBGetProgress)progressBlock success:(void (^)(id response))success failure:(void (^)(NSError *error))failure{
    //将session拷贝到堆中，block内部才可以获取得到session
    __block ZBURLSessionTask *session = nil;
    
    //网络验证
    if (networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (failure) {
            failure(nil);
        }
        return session;
    }
    
    [[self manager] GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseData:responseObject];
        if (success && isValid) {
            success(responseObject);
        }
        [[ZBNetwork allTasks] removeObject:session];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(nil);
        [[ZBNetwork allTasks] removeObject:session];
    }];
    
    if ([self haveSameRequestInTasksPool:session]) {
        //取消新请求
        [session cancel];
        return session;
    }else {
        //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
        ZBURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
//        if (oldTask) [[ZBNetwork allTasks] removeObject:oldTask];
        if (session) [[ZBNetwork allTasks] addObject:session];
        [session resume];
        return session;
    }
}



#pragma mark - 判断网络请求池中是否有相同的请求
/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return bool
 */
- (BOOL)haveSameRequestInTasksPool:(ZBURLSessionTask *)task {
    __block BOOL isSame = NO;
    [[ZBNetwork allTasks] enumerateObjectsUsingBlock:^(ZBURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            isSame  = YES;
            *stop = YES;
        }
    }];
    return isSame;
}


/**
 *  如果有旧请求则取消旧请求
 *
 *  @param task 新请求
 *
 *  @return 旧请求
 */
- (ZBURLSessionTask *)cancleSameRequestInTasksPool:(ZBURLSessionTask *)task {
    __block ZBURLSessionTask *oldTask = nil;
    
    [[ZBNetwork allTasks] enumerateObjectsUsingBlock:^(ZBURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.originalRequest isTheSameRequest:obj.originalRequest]) {
            if (obj.state == NSURLSessionTaskStateRunning) {
                [obj cancel];
                oldTask = obj;
            }
            *stop = YES;
        }
    }];
    
    return oldTask;
}

#pragma mark - 网络回调统一处理
//网络回调统一处理
- (BOOL)networkResponseData:(id)responseObject{
    NSData *data = nil;
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        data = responseObject;
    }else if ([responseObject isKindOfClass:[NSDictionary class]]){
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //    NSLog(@"%@",json);
    
    //统一判断所有请求返回状态，例如：强制更新为6，若为6就返回YES，
    int stat = 0;
    switch (stat) {
        case -1:{//强制退出
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                DBLog(@"点击了取消");
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                DBLog(@"点击了确定");
            }]];
            
            UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            [rootViewController presentViewController:alert animated:YES completion:^{
                
            }];
            return NO;
        }
            break;
        case -2:{//强制更新
            return NO;
        }
            break;
        case -3:{//弹出对话框
            return NO;
        }
            break;
        default:
            break;
    }
    return YES;
}

@end
