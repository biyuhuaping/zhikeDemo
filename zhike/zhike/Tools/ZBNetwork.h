//
//  ZBNetwork.h
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBNetwork : NSObject

/**
 *  请求任务
 */
typedef NSURLSessionTask ZBURLSessionTask;

/**
 *  成功回调
 *  @param response 成功后返回的数据
 */
typedef void(^ZBResponseSuccessBlock)(id response);


/**
 *  失败回调
 *  @param error 失败后返回的错误信息
 */
typedef void(^ZBResponseFailBlock)(NSError *error);

/**
 *  下载进度
 *  @param bytesRead    已下载的大小
 *  @param totalBytes   总下载大小
 */
typedef void (^ZBDownloadProgress)(int64_t bytesRead, int64_t totalBytes);

/**
 *  下载成功回调
 *  @param url  下载存放的路径
 */
typedef void(^ZBDownloadSuccessBlock)(NSURL *url);


/**
 *  上传进度
 *  @param bytesWritten 已上传的大小
 *  @param totalBytes   总上传大小
 */
typedef void(^ZBUploadProgressBlock)(int64_t bytesWritten, int64_t totalBytes);
/**
 *  多文件上传成功回调
 *  @param responses 成功后返回的数据
 */
typedef void(^ZBMultUploadSuccessBlock)(NSArray *responses);

/**
 *  多文件上传失败回调
 *  @param errors 失败后返回的错误信息
 */
typedef void(^ZBMultUploadFailBlock)(NSArray *errors);
typedef void(^ZBMultUploadFailBlock)(NSArray *errors);
typedef ZBDownloadProgress ZBGetProgress;
typedef ZBDownloadProgress ZBPostProgress;
typedef ZBResponseFailBlock ZBDownloadFailBlock;

+ (instancetype)shaerdInstance;
- (ZBURLSessionTask *)getWithUrl:(NSString *)url hud:(BOOL)hud parameters:(NSDictionary *)params progressBlock:(ZBGetProgress)progressBlock success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
- (ZBURLSessionTask *)getWithUrl:(NSString *)url params:(NSDictionary *)params progressBlock:(ZBGetProgress)progressBlock successBlock:(ZBResponseSuccessBlock)successBlock failBlock:(ZBResponseFailBlock)failBlock;
@end
