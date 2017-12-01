//
//  ZBUrlArgumentFilter.m
//  zhike
//
//  Created by 周博 on 2017/12/1.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBUrlArgumentFilter.h"

@implementation ZBUrlArgumentFilter{
    NSDictionary *_arguments;
}

+ (ZBUrlArgumentFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

//在实际发送URL之前对其进行预处理
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    return @"";//[self urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}

@end
