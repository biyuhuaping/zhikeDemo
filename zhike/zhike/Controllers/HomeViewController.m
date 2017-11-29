//
//  HomeViewController.m
//  zhike
//
//  Created by 周博 on 2017/11/24.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "HomeViewController.h"
#import <MJExtension.h>
#import <YTKNetwork.h>
#import "YQNetworking.h"

#import "User.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"缓存size is %lu",[YQNetworking totalCacheSize]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";
    [YQNetworking shaerdInstance]
    [YQNetworking getWithUrl:url refreshRequest:YES cache:NO params:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
//        NSLog(@"%lld--%lld",bytesRead,totalBytes);
    } successBlock:^(id response) {
//        NSLog(@"%@",response);
        User *user = [User mj_objectWithKeyValues:response];
        DBLOG(@"%@,%@",user.stories[0][@"title"],user.stories[0][@"id"]);
    } failBlock:^(NSError *error) {
        DBLOG(@"%@",error);
    }];
    
    NSLog(@"缓存size is %lu",[YQNetworking totalCacheSize]);
}

@end
