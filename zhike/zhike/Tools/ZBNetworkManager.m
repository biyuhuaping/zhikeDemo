//
//  ZBNetworkManager.m
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBNetworkManager.h"

@interface ZBNetworkManager ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation ZBNetworkManager

static ZBNetworkManager *networkManager = nil;
/**
 *  单例
 *
 *  @return 网络请求类的实例，可在请求时直接调用方法，也是一个直接初始化的方式
 */
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!networkManager) {
            networkManager = [[ZBNetworkManager alloc] init];
        }
    });
    return networkManager;
}


/**
 初始化，APP每次启动时会调用该方法，运行时不会调用
 
 @return 基本的请求设置
 */
- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        // 设置请求以及相应的序列化器
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

        // 设置超时时间
        self.sessionManager.requestSerializer.timeoutInterval = 20.0;
        // 设置响应内容的类型
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
    }
    return self;
}

#pragma mark - GET, POST 网络请求
/**
 get请求
 */
- (void)GET:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters success:(void (^_Nonnull)(id _Nullable  response))success failure:(void (^_Nonnull)(NSError * _Nullable error))failure{
    [self sendRequestMethod:HTTPMethodGET serverUrl:@"" apiPath:@"" parameters:parameters progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseData:responseObject];
        if (success && isValid) {
            success(responseObject);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure([errorMessage copy]);
    }];
}

/**
 post请求
 */
- (void)POST:(NSString *_Nullable)URLString parameters:(NSDictionary *_Nullable)parameters success:(void (^_Nonnull)(id _Nullable  response))success failure:(void (^_Nonnull)(NSError * _Nullable error))failure{
    [self sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:@"" parameters:parameters progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
        BOOL isValid = [self networkResponseData:responseObject];
        if (success && isValid) {
            success(responseObject);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure([errorMessage copy]);
    }];
}


#pragma mark - 
#pragma mark - 常用网络请求(GET, POST, PUT, PATCH, DELETE)
/**
 常用网络请求方式
 
 @param requestMethod 请求方试
 @param serverUrl 服务器地址
 @param apiPath 方法的链接
 @param parameters 参数
 @param progress 进度
 @param success 成功
 @param failure 失败
 @return return value description
 */
- (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod serverUrl:(nonnull NSString *)serverUrl apiPath:(nonnull NSString *)apiPath parameters:(nullable id)parameters progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString * _Nullable errorMessage))failure {
    // 请求的地址
    NSString *requestPath = [serverUrl stringByAppendingPathComponent:apiPath];
    NSURLSessionDataTask * task = nil;
    switch (requestMethod) {
        case HTTPMethodGET:
        {
            task = [self.sessionManager GET:requestPath parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPOST:
        {
            task = [self.sessionManager POST:requestPath parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPUT:
        {
            task = [self.sessionManager PUT:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPATCH:
        {
            task = [self.sessionManager PATCH:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodDELETE:
        {
            task = [self.sessionManager DELETE:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failure) {
                        failure([self failHandleWithErrorResponse:error task:task]);
                    }
                }];
        }
            break;
    }
    return task;
}

#pragma mark POST 上传图片

/**
 上传图片
 
 @param serverUrl 服务器地址
 @param apiPath 方法的链接
 @param parameters 参数
 @param imageArray 图片
 @param width 图片宽度
 @param progress 进度
 @param success 成功
 @param failure 失败
 @return return value description
 */
- (nullable NSURLSessionDataTask *)sendPOSTRequestWithserverUrl:(nonnull NSString *)serverUrl apiPath:(nonnull NSString *)apiPath parameters:(nullable id)parameters imageArray:(NSArray *_Nullable)imageArray targetWidth:(CGFloat )width progress:(nullable void (^)(NSProgress * _Nullable progress))progress success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success failure:(nullable void(^) (NSString *_Nullable error))failure {
    // 请求的地址
    NSString *requestPath = [serverUrl stringByAppendingPathComponent:apiPath];
    NSURLSessionDataTask * task = nil;
    task = [self.sessionManager POST:requestPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSUInteger i = 0 ;
        // 上传图片时，为了用户体验或是考虑到性能需要进行压缩
        for (UIImage * image in imageArray) {
            // 压缩图片，指定宽度（注释：imageCompressed：withdefineWidth：图片压缩的category）
//            UIImage *  resizedImage =  [UIImage imageCompressed:image withdefineWidth:width];
            NSData * imgData = UIImageJPEGRepresentation(image, 0.5);
            // 拼接Data
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
            i++;
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)success(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure([self failHandleWithErrorResponse:error task:task]);
    }];
    return task;
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

#pragma mark 报错信息
/**
 处理报错信息
 
 @param error AFN返回的错误信息
 @param task 任务
 @return description
 */
- (NSString *)failHandleWithErrorResponse:( NSError * _Nullable )error task:( NSURLSessionDataTask * _Nullable )task {
    // 这里可以直接设定错误反馈，也可以利用AFN 的error信息直接解析展示
    NSData *afNetworking_errorMsg = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    DBLOG(@"afNetworking_errorMsg == %@",[[NSString alloc]initWithData:afNetworking_errorMsg encoding:NSUTF8StringEncoding]);
    __block NSString *message = nil;
    if (!afNetworking_errorMsg) {
        message = @"网络连接失败";
    }
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger responseStatue = response.statusCode;
    if (responseStatue >= 500) {  // 网络错误
        message = @"服务器维护升级中,请耐心等待";
    } else if (responseStatue >= 400) {
        // 错误信息
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:afNetworking_errorMsg options:NSJSONReadingAllowFragments error:nil];
        message = responseObject[@"error"];
    }
    DBLOG(@"error == %@",error);
    return message;
}

@end
