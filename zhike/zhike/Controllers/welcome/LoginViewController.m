//
//  LoginViewController.m
//  zhike
//
//  Created by 周博 on 2018/1/18.
//  Copyright © 2018年 zhoubo. All rights reserved.
//

#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "BindingViewController.h"

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
    //正常状态下的背景颜色
    UIColor *mainColor = [UIColor colorWithRed:84/255.0 green:180/255.0 blue:98/255.0 alpha:1.0f];
    //倒计时状态下的颜色
    UIColor *countColor = [UIColor lightGrayColor];
    [self setTheCountdownButton:sender startWithTime:10 title:@"获取验证码" countDownTitle:@"s" mainColor:mainColor countColor:countColor];
}

//登录
- (IBAction)loginButtonTap:(id)sender {
    BindingViewController *bindView = [[BindingViewController alloc]initWithNibName:@"BindingViewController" bundle:nil];
    [self.navigationController pushViewController:bindView animated:YES];
}

#pragma mark - button倒计时
- (void)setTheCountdownButton:(UIButton *)button startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0), 1.0 * NSEC_PER_SEC,0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = mColor;
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeOut % 60;
            NSString *timeStr = [NSString stringWithFormat:@"%0.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = color;
                [button setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle]forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 第三方登录
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
//    self.textField1 = nil;
//    self.textField2 = nil;
}

@end
