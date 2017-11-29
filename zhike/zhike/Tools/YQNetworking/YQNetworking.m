//
//  YQNetworking.m
//  YQNetworking
//
//  Created by yingqiu huang on 2017/2/10.
//  Copyright © 2017年 yingqiu huang. All rights reserved.
//

#import "YQNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YQCacheManager.h"

#define YQ_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"
#define YQ_ERROR [NSError errorWithDomain:@"com.hyq.YQNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:YQ_ERROR_IMFORMATION}]

static NSMutableArray   *requestTasksPool;
static NSDictionary     *headers;
static YQNetworkStatus  networkStatus;
static NSTimeInterval   requestTimeout = 20.f;




@implementation NSURLRequest (decide)
//判断是否是同一个请求（依据是请求url和参数是否相同）
- (BOOL)isTheSameRequest:(NSURLRequest *)request {
    if ([self.HTTPMethod isEqualToString:request.HTTPMethod]) {
        if ([self.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
            if ([self.HTTPMethod isEqualToString:@"GET"]||[self.HTTPBody isEqualToData:request.HTTPBody]) {
                DBLOG(@"同一个请求还没执行完，又来请求☹️");
                return YES;
            }
        }
    }
    return NO;
}

@end


@interface YQNetworking()
//@property (copy, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation YQNetworking

+ (void)initialize{
    [self checkNetworkStatus];//开始监听网络
}

+ (instancetype)shaerdInstance{
    static YQNetworking *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

//- (AFHTTPSessionManager *)manager {
//    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
//    //配置请求序列化
//    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//    [serializer setRemovesKeysWithNullValues:YES];
//
//    _manager = [AFHTTPSessionManager manager];
//    //默认解析模式
//    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
//    _manager.requestSerializer.timeoutInterval = requestTimeout;
//
//    for (NSString *key in headers.allKeys) {
//        if (headers[key] != nil) {
//            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
//        }
//    }
//
//    //配置响应序列化
//    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
//
//    return _manager;
//}

#pragma mark - manager
+ (AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
    
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[YQCacheManager shareManager] setCacheTime: diskCapacity:]设置
    [[YQCacheManager shareManager] clearLRUCache];
    return manager;
}

//检查网络
+ (void)checkNetworkStatus {
    // 检测网络连接的单例,网络变化时的回调方法
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DBLOG(@"网络状态 : %@", @(status));
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = YQNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = YQNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = YQNetworkStatusReachableViaWiFi;
                break;
            default:
                networkStatus = YQNetworkStatusUnknown;
                break;
        }
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

#pragma mark - get
+ (YQURLSessionTask *)getWithUrl:(NSString *)url refreshRequest:(BOOL)refresh cache:(BOOL)cache params:(NSDictionary *)params progressBlock:(YQGetProgress)progressBlock successBlock:(YQResponseSuccessBlock)successBlock failBlock:(YQResponseFailBlock)failBlock {
    //将session拷贝到堆中，block内部才可以获取得到session
    __block YQURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self];
    
    //网络验证
    if (networkStatus == YQNetworkStatusNotReachable) {
        if (failBlock) {
            failBlock(YQ_ERROR);
        }
        return session;
    }
    id responseObj = [[YQCacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:params];
    if (responseObj && cache) {
        if (successBlock) {
            successBlock(responseObj);
        }
    }
    session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseData:responseObject];
        if (successBlock && isValid) {
            successBlock(responseObject);
        }
        if (cache) {
            [[YQCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
        }
        [[self allTasks] removeObject:session];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) failBlock(error);
        [[self allTasks] removeObject:session];
    }];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        //取消新请求
        [session cancel];
        return session;
    }else {
        //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
        YQURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
}

#pragma mark post
+ (YQURLSessionTask *)postWithUrl:(NSString *)url refreshRequest:(BOOL)refresh cache:(BOOL)cache params:(NSDictionary *)params progressBlock:(YQPostProgress)progressBlock successBlock:(YQResponseSuccessBlock)successBlock failBlock:(YQResponseFailBlock)failBlock {
    __block YQURLSessionTask *session = nil;
    AFHTTPSessionManager *manager = [self manager];
    if (networkStatus == YQNetworkStatusNotReachable) {
        if (failBlock) {
            failBlock(YQ_ERROR);
            return session;
        }
    }
    id responseObj = [[YQCacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:params];
    if (responseObj && cache) {
        if (successBlock) successBlock(responseObj);
    }
    session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseData:responseObject];
        if (successBlock && isValid) successBlock(responseObject);
        if (cache) [[YQCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
        if ([[self allTasks] containsObject:session]) {
            [[self allTasks] removeObject:session];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) failBlock(error);
        [[self allTasks] removeObject:session];
    }];
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        [session cancel];
        return session;
    }else {
        YQURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
}

#pragma mark 文件上传
+ (YQURLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(YQUploadProgressBlock)progressBlock
                           successBlock:(YQResponseSuccessBlock)successBlock
                              failBlock:(YQResponseFailBlock)failBlock {
    __block YQURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == YQNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR);
        return session;
    }
    
    session = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = nil;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *day = [formatter stringFromDate:[NSDate date]];
        fileName = [NSString stringWithFormat:@"%@.%@",day,type];
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) successBlock(responseObject);
        [[self allTasks] removeObject:session];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) failBlock(error);
        [[self allTasks] removeObject:session];
    }];
    
    
    [session resume];
    if (session) [[self allTasks] addObject:session];
    return session;
}

#pragma mark 多文件上传
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                     progressBlock:(YQUploadProgressBlock)progressBlock
                      successBlock:(YQMultUploadSuccessBlock)successBlock
                         failBlock:(YQMultUploadFailBlock)failBlock {
    
    if (networkStatus == YQNetworkStatusNotReachable) {
        if (failBlock) failBlock(@[YQ_ERROR]);
        return nil;
    }
    
    __block NSMutableArray *sessions = [NSMutableArray array];
    __block NSMutableArray *responses = [NSMutableArray array];
    __block NSMutableArray *failResponse = [NSMutableArray array];
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    
    NSInteger count = datas.count;
    for (int i = 0; i < count; i++) {
        __block YQURLSessionTask *session = nil;
        
        dispatch_group_enter(uploadGroup);
        
        session = [self uploadFileWithUrl:url
                                 fileData:datas[i]
                                     type:type name:name
                                 mimeType:mimeTypes
                            progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
                                if (progressBlock) progressBlock(bytesWritten,
                                                                 totalBytes);
                                
                            } successBlock:^(id response) {
                                [responses addObject:response];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                                
                            } failBlock:^(NSError *error) {
                                NSError *Error = [NSError errorWithDomain:url code:-999 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"第%d次上传失败",i]}];
                                
                                [failResponse addObject:Error];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                            }];
        
        [session resume];
        
        if (session) [sessions addObject:session];
    }
    
    [[self allTasks] addObjectsFromArray:sessions];
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (responses.count > 0) {
            if (successBlock) {
                successBlock([responses copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
        if (failResponse.count > 0) {
            if (failBlock) {
                failBlock([failResponse copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
    });
    
    return [sessions copy];
}

#pragma mark 下载
+ (YQURLSessionTask *)downloadWithUrl:(NSString *)url progressBlock:(YQDownloadProgress)progressBlock successBlock:(YQDownloadSuccessBlock)successBlock failBlock:(YQDownloadFailBlock)failBlock {
    NSString *type = nil;
    NSArray *subStringArr = nil;
    __block YQURLSessionTask *session = nil;
    
    NSURL *fileUrl = [[YQCacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
    if (fileUrl) {
        if (successBlock) successBlock(fileUrl);
        return nil;
    }
    
    if (url) {
        subStringArr = [url componentsSeparatedByString:@"."];
        if (subStringArr.count > 0) {
            type = subStringArr[subStringArr.count - 1];
        }
    }
    
    AFHTTPSessionManager *manager = self.magnager;
    //响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session = [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            NSData *dataObj = (NSData *)responseObject;
            [[YQCacheManager shareManager] storeDownloadData:dataObj requestUrl:url];
            NSURL *downFileUrl = [[YQCacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
            successBlock(downFileUrl);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock (error);
        }
    }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - 判断网络请求池中是否有相同的请求
/**
 *  判断网络请求池中是否有相同的请求
 *
 *  @param task 网络请求任务
 *
 *  @return bool
 */
+ (BOOL)haveSameRequestInTasksPool:(YQURLSessionTask *)task {
    __block BOOL isSame = NO;
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(YQURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
+ (YQURLSessionTask *)cancleSameRequestInTasksPool:(YQURLSessionTask *)task {
    __block YQURLSessionTask *oldTask = nil;
    
    [[self currentRunningTasks] enumerateObjectsUsingBlock:^(YQURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

#pragma mark - other method
+ (void)setupTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

+ (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(YQURLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YQURLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(YQURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YQURLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}

+ (NSArray *)currentRunningTasks {
    return [[self allTasks] copy];
}

#pragma mark - 网络回调统一处理
//网络回调统一处理
+ (BOOL)networkResponseData:(id)responseObject{
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









#pragma mark -
@implementation YQNetworking (cache)
+ (NSUInteger)totalCacheSize {
    return [[YQCacheManager shareManager] totalCacheSize];
}

+ (NSUInteger)totalDownloadDataSize {
    return [[YQCacheManager shareManager] totalDownloadDataSize];
}

+ (void)clearDownloadData {
    [[YQCacheManager shareManager] clearDownloadData];
}

+ (NSString *)getDownDirectoryPath {
    return [[YQCacheManager shareManager] getDownDirectoryPath];
}

+ (NSString *)getCacheDiretoryPath {
    
    return [[YQCacheManager shareManager] getCacheDiretoryPath];
}

+ (void)clearTotalCache {
    [[YQCacheManager shareManager] clearTotalCache];
}

@end
