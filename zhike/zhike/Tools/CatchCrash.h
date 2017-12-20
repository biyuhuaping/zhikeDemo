//
//  CatchCrash.h
//  zhike
//
//  Created by 周博 on 2017/12/19.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatchCrash : NSObject

void uncaughtExceptionHandler(NSException *exception);

@end
