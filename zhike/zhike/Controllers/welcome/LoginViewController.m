//
//  LoginViewController.m
//  zhike
//
//  Created by 周博 on 2018/1/18.
//  Copyright © 2018年 zhoubo. All rights reserved.
//

#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField1;
@property (strong, nonatomic) IBOutlet UITextField *textField2;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.codeButton.layer.cornerRadius = 4;
    self.loginButton.layer.cornerRadius = 4;
    self.lineHeight.constant = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
//    DBLOG(@"%u",self.tabBarController.selectedIndex);
//    if (self.tabBarController.selectedIndex == 2) {
//        [self.tabBarController setSelectedIndex:0];
//    }
}

//获取验证码
- (IBAction)codeButtonTap:(id)sender {
}

//登录
- (IBAction)loginButtonTap:(id)sender {
}

//微信登录
- (IBAction)wechatButtonTap:(id)sender {
    [self getUserInfoForPlatform:1];
}

//QQ登录
- (IBAction)QQButtonTap:(id)sender {
    [self getUserInfoForPlatform:5];
}

//新浪微博登录
- (IBAction)SinaButtonTap:(id)sender {
    [self getUserInfoForPlatform:0];
}

//淘宝登录
- (IBAction)taobaoButtonTap:(id)sender {
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
}

- (void)dealloc{
    self.textField1 = nil;
    self.textField2 = nil;
}

@end
