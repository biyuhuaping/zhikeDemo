//
//  ZBMemoryCache.m
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBMemoryCache.h"
#import <UIKit/UIKit.h>

static NSCache *shareCache;

@implementation ZBMemoryCache

+ (NSCache *)shareCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareCache == nil) shareCache = [[NSCache alloc] init];
    });
    
    //当收到内存警报时，清空内存缓存
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [shareCache removeAllObjects];
    }];
    return shareCache;
}

+ (void)writeData:(id)data forKey:(NSString *)key {
    assert(data);
    assert(key);
    NSCache *cache = [ZBMemoryCache shareCache];
    [cache setObject:data forKey:key];
}

+ (id)readDataWithKey:(NSString *)key {
    assert(key);
    id data = nil;
    NSCache *cache = [ZBMemoryCache shareCache];
    data = [cache objectForKey:key];
    return data;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

@end
