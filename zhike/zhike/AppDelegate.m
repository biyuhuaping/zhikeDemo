//
//  AppDelegate.m
//  zhike
//
//  Created by 周博 on 2017/11/24.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import <YTKNetwork.h>
#import "ZBUrlArgumentFilter.h"
#import "CatchCrash.h"

@interface AppDelegate ()
@property (strong, nonatomic) BaseTabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self showTabbarController];
    [self setupRequestFilters];
//    [self ddLog];
    
    
    //注册消息处理函数的处理方法
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    //发送崩溃日志
    NSString *path = [NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data != nil) {
        [self sendExceptionLogWithData:data];
    }
    
    return YES;
}

- (void)setupRequestFilters {
//    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"https://news-at.zhihu.com";
//    config.cdnUrl = @"http://fen.bi";
    
//    ZBUrlArgumentFilter *urlFilter = [ZBUrlArgumentFilter filterWithArguments:@{@"version": appVersion}];
//    [config addUrlFilter:urlFilter];
}

- (void)showTabbarController{
    self.tabBarController = [[BaseTabBarController alloc] init];
    self.window.rootViewController = self.tabBarController;
    NSLog(@"我来了！");
}

#pragma mark -- 发送崩溃日志
- (void)sendExceptionLogWithData:(NSData *)data{
    NSString *url = @"";
    [[ZBNetworking shaerdInstance]uploadFileWithUrl:url fileData:data type:@"log" name:@"error" mimeType:@"log" progressBlock:nil successBlock:^(id response) {
        DBLOG(@"日志上传成功");
    } failBlock:^(NSError *error) {
        DBLOG(@"日志上传失败");
    }];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 5.0f;
//    //告诉AFN，支持接受 text/xml 的数据
//    [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    NSString *urlString = @"后台地址";
//
//    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:data name:@"file" fileName:@"Exception.txt" mimeType:@"txt"];
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//    }];
}

//- (void)ddLog{
//    // 添加DDASLLogger，你的日志语句将被发送到Xcode控制台
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
//
//    // 添加DDTTYLogger，你的日志语句将被发送到Console.app
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
//
//    // 添加DDFileLogger，你的日志语句将写入到一个文件中，默认路径在沙盒的Library/Caches/Logs/目录下，文件名为bundleid+空格+日期.log。
//    //下面的代码告诉应用程序要在系统上保持一周的日志文件
//    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
//    fileLogger.rollingFrequency = 60 * 60 * 24;
//    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
//    [DDLog addLogger:fileLogger];
//
//    //产生Log
//    DDLogError(@"[Error]:%@", @"输出错误信息");//输出错误信息
//    DDLogWarn(@"[Warn]:%@", @"输出警告信息");//输出警告信息
//    DDLogInfo(@"[Info]:%@", @"输出描述信息");//输出描述信息
//    DDLogDebug(@"[Debug]:%@", @"输出调试信息");//输出调试信息
//    DDLogVerbose(@"[Verbose]:%@", @"输出详细信息");//输出详细信息
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
