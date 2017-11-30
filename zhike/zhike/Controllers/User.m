//
//  User.m
//  zhike
//
//  Created by 周博 on 2017/11/28.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "User.h"

@implementation User

- (NSString *)requestUrl {
    // “http://www.yuantiku.com” 在 YTKNetworkConfig 中设置，这里只填除去域名剩余的网址信息
    return @"/api/4/news/latest";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

//- (id)requestArgument {
//    return nil;
//}

@end
