//
//  ZBUrlArgumentFilter.h
//  zhike
//
//  Created by 周博 on 2017/12/1.
//  Copyright © 2017年 zhoubo. All rights reserved.
//  通过本类，我们就可以方便地为网络请求增加统一的参数，如增加当前客户端的版本号

#import <Foundation/Foundation.h>
#import "YTKNetworkConfig.h"

@interface ZBUrlArgumentFilter : NSObject<YTKUrlFilterProtocol>

+ (ZBUrlArgumentFilter *)filterWithArguments:(NSDictionary *)arguments;
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

@end
