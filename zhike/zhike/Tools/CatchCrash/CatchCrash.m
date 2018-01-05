//
//  CatchCrash.m
//  zhike
//
//  Created by 周博 on 2017/12/19.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "CatchCrash.h"

@implementation CatchCrash

+ (void)initialize{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

// 出现崩溃时的回调函数
void uncaughtExceptionHandler(NSException *exception){
    //获取系统当前时间，（注：用[NSDate date]直接获取的是格林尼治时间，有时差）
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *crashTime = [formatter stringFromDate:[NSDate date]];
    
    NSString *app_Version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]; //app版本
    NSString *systemVersion = [[NSProcessInfo processInfo] operatingSystemVersionString];//系统版本

    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason]; //可以有崩溃的原因(数组越界/字典nil/调用未知方法...) 崩溃的控制器以及方法
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"========异常错误报告 %@========\n name:%@\n app_Version:%@\n systemVersion:%@\n reason:%@\n callStackSymbols:\n%@",crashTime,name,app_Version,systemVersion,reason,[stackArray componentsJoinedByString:@"\n"]];
    
    // 将txt文件写入沙盒
    NSString *path = [NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()];
    [exceptionInfo writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
