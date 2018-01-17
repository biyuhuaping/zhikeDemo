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
#import <OpenShare/OpenShareHeader.h>

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
    [self configRequestFilters];
    [self configOpenShare];
    [self sendExceptionLog];
    
    return YES;
}

//配置OpenShare
- (void)configOpenShare{
    //全局注册appId，别忘了#import "OpenShareHeader.h"
    [OpenShare connectQQWithAppId:@"1103194207"];
    [OpenShare connectWeiboWithAppKey:@"402180334"];
    [OpenShare connectWeixinWithAppId:@"wxd930ea5d5a258f4f"];
    [OpenShare connectRenrenWithAppId:@"228525" AndAppKey:@"1dd8cba4215d4d4ab96a49d3058c1d7f"];
}

//配置请求
- (void)configRequestFilters {
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

#pragma mark - 发送崩溃日志
- (void)sendExceptionLog{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data == nil) {
        return;//如果没有崩溃日志，就return
    }
    
    NSString *url = @"http://p190ktt6s.bkt.clouddn.com/Exception.txt";
    [ZBNetworking getWithUrl:url cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        DBLOG(@"下载成功\n%@",response);
        id json = [NSJSONSerialization JSONObjectWithData:(NSData *)response options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
        DBLOG(@"json:%@",json);
    } failBlock:^(NSError *error) {
        DBLOG(@"下载失败%@",error.userInfo);
    }];

    NSString *uploadURL = @"http://p190ktt6s.bkt.clouddn.com/";
    [ZBNetworking uploadFileWithUrl:uploadURL fileData:data name:@"file" fileName:@"error.log" mimeType:@"txt" progressBlock:nil successBlock:^(id response) {
        DBLOG(@"日志上传成功");
    } failBlock:^(NSError *error) {
        DBLOG(@"日志上传失败%@",error.userInfo);
    }];
}

#pragma mark -
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
