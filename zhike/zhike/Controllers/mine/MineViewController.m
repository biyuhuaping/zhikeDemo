//
//  MineViewController.m
//  zhike
//
//  Created by 周博 on 2017/11/24.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "MineViewController.h"
#import "HomeViewController.h"
#import <OpenShare/OpenShareHeader.h>

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//微信登录
- (IBAction)WeixinAuth:(id)sender {
    //比如微信登录，其他登录可以参考文档或者代码，或者让Xcode自动提示。
    [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary *message) {
        DBLOG(@"微信登录成功:\n%@",message);
    } Fail:^(NSDictionary *message, NSError *error) {
        DBLOG(@"微信登录失败:\n%@\n%@",message,error);
    }];
}

- (IBAction)weixinShare:(id)sender {
    //分享纯文本消息到微信朋友圈，其他类型可以参考示例代码
    OSMessage *msg = [[OSMessage alloc]init];
    msg.title=@"Hello msg.title";
    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
        DBLOG(@"微信分享到朋友圈成功：\n%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        DBLOG(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";
    [ZBNetworking getWithUrl:url cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        id json = [NSJSONSerialization JSONObjectWithData:(NSData *)response options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
        DBLOG(@"json:%@",json[@"stories"][0][@"title"]);
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    //    HomeViewController *home = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    //    [self.navigationController pushViewController:home animated:YES];
}

@end
