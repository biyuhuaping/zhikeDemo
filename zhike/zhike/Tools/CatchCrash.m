//
//  CatchCrash.m
//  zhike
//
//  Created by 周博 on 2017/12/19.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "CatchCrash.h"

@implementation CatchCrash

// 出现崩溃时的回调函数
void uncaughtExceptionHandler(NSException *exception){
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason]; //可以有崩溃的原因(数组越界/字典nil/调用未知方法...) 崩溃的控制器以及方法
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"========异常错误报告========\n name:%@\n reason:%@\n callStackSymbols:\n%@",name,reason,[stackArray componentsJoinedByString:@"\n"]];
    
    // 将txt文件写入沙盒
    NSString *path = [NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()];
    [exceptionInfo writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
