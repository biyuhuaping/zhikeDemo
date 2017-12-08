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
#import "ZBNetworking.h"
#import "ZBNetworkManager.h"

#import "User.h"
#import "RegisterModel.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"缓存size is %lu",[ZBNetworking totalCacheSize]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击返回按钮，将所有的文本框失焦
//    [[UIApplication sharedApplication] resignFirstResponder];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ZBNetworking:(id)sender {
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";
    [[ZBNetworking shaerdInstance]getWithUrl:url cache:NO params:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        NSLog(@"%lld--%lld",bytesRead,totalBytes);
//        [NSThread sleepForTimeInterval:5];
    } successBlock:^(id response) {
        //        NSLog(@"%@",response);
        User *user = [User mj_objectWithKeyValues:response];
        DBLOG(@"%@,%@",user.stories[0][@"title"],user.stories[0][@"id"]);
    } failBlock:^(NSError *error) {
//        DBLOG(@"%@",error);
    }];
    NSLog(@"缓存size is %lu",(unsigned long)[[ZBNetworking shaerdInstance]totalCacheSize]);
}

- (IBAction)ZBNetworkManager:(id)sender {
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";    
    [[ZBNetworkManager defaultManager]sendRequestMethod:HTTPMethodGET serverUrl:url apiPath:@"" parameters:nil progress:^(NSProgress * _Nullable progress) {
        DBLOG(@"======");
//        [NSThread sleepForTimeInterval:5];
    } success:^(BOOL isSuccess, id  _Nullable responseObject) {
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
//        DBLOG(@"%@",[request responseJSONObject]);
//
//    } failure:^(YTKBaseRequest *request) {
//        // 你可以直接在这里使用 self
//        NSLog(@"failed");
//    }];

    __block User *user = [[User alloc]init];
    [user startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        id response = [request responseData];
        DBLOG(@"%@",response);
        user = [User mj_objectWithKeyValues:response];
        DBLOG(@"%@,%@",user.stories[0][@"title"],user.stories[0][@"id"]);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        DBLOG(@"请求失败：%@",request);
    }];
}




- (void)dealloc{
    DBLOG(@"dealloc");
}
@end
