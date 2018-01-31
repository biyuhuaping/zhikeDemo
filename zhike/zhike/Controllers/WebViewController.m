//
//  WebViewController.m
//  zhike
//
//  Created by 周博 on 2018/1/31.
//  Copyright © 2018年 zhoubo. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.navigationDelegate = self;//需要实现WKNavigationDelegate
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:self.URLString]]];
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            if (self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

@end
