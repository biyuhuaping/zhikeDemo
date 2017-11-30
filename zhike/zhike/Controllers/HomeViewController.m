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
#import "ZBNetwork.h"
#import "ZBNetworkManager.h"

#import "User.h"
#import "RegisterModel.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"缓存size is %lu",[YQNetworking totalCacheSize]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)YQ:(id)sender {
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";
    [YQNetworking getWithUrl:url refreshRequest:YES cache:NO params:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        //        NSLog(@"%lld--%lld",bytesRead,totalBytes);
    } successBlock:^(id response) {
        //        NSLog(@"%@",response);
        User *user = [User mj_objectWithKeyValues:response];
        DBLOG(@"%@,%@",user.stories[0][@"title"],user.stories[0][@"id"]);
    } failBlock:^(NSError *error) {
        DBLOG(@"%@",error);
    }];
//    NSLog(@"缓存size is %lu",[YQNetworking totalCacheSize]);
}

- (IBAction)ZB:(id)sender {
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";
//    [[ZBNetwork shaerdInstance]getWithUrl:url hud:YES parameters:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
//        //        DBLOG(@"%lld--%lld",bytesRead,totalBytes);
//    } success:^(id response) {
//        User *user = [User mj_objectWithKeyValues:response];
//        DBLOG(@"%@,%@",user.stories[0][@"title"],user.stories[0][@"id"]);
//    } failure:^(NSError *error) {
//        DBLOG(@"%@",error);
//    }];
    
//    [[ZBNetwork shaerdInstance]getWithUrl:url params:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
//    } successBlock:^(id response) {
//        User *user = [User mj_objectWithKeyValues:response];
//        DBLOG(@"%@,%@",user.stories[0][@"title"],user.stories[0][@"id"]);
//    } failBlock:^(NSError *error) {
//        DBLOG(@"%@",error);
//    }];
    
    [[ZBNetworkManager defaultManager]sendRequestMethod:HTTPMethodGET serverUrl:url apiPath:@"" parameters:nil progress:nil success:^(BOOL isSuccess, id  _Nullable responseObject) {
        User *user = [User mj_objectWithKeyValues:responseObject];
        DBLOG(@"%@,%@",user.stories[0][@"title"],user.stories[0][@"id"]);
    } failure:^(NSString * _Nullable errorMessage) {
        DBLOG(@"%@",errorMessage);
    }];
}

- (IBAction)YTK:(id)sender {
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";
    
//    RegisterModel *api = [[RegisterModel alloc] initWithUsername:@"usernamebiyuhuaping" password:@"123456"];
//    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//        // 你可以直接在这里使用 self
//        NSLog(@"succeed");
//
//    } failure:^(YTKBaseRequest *request) {
//        // 你可以直接在这里使用 self
//        NSLog(@"failed");
//    }];
    User * user = [[User alloc]init];
    [user startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        DBLOG(@"%@",request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DBLOG(@"请求失败：%@",request);
    }];
}




- (void)dealloc{
    
}
@end
