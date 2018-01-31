//
//  QuestionViewController.m
//  zhike
//
//  Created by 周博 on 2017/11/24.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "QuestionViewController.h"
#import "HomeViewController.h"
#import <WebKit/WebKit.h>

@interface QuestionViewController ()<WKNavigationDelegate>

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    WKWebView *webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.navigationDelegate = self;//需要实现WKNavigationDelegate
    [webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"http://www.zhikekeji.cn"]]];
    [self.view addSubview:webView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    HomeViewController *home = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//    [self.navigationController pushViewController:home animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation




@end
