//
//  BindingViewController.m
//  zhike
//
//  Created by 周博 on 2018/1/24.
//  Copyright © 2018年 zhoubo. All rights reserved.
//

#import "BindingViewController.h"

@interface BindingViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField1;
@property (strong, nonatomic) IBOutlet UITextField *textField2;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定手机号";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.codeButton.layer.cornerRadius = 4;
    self.nextButton.layer.cornerRadius = 4;
    self.lineHeight.constant = 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取验证码
- (IBAction)codeButtonTap:(id)sender {
    //正常状态下的背景颜色
    UIColor *mainColor = [UIColor colorWithRed:84/255.0 green:180/255.0 blue:98/255.0 alpha:1.0f];
    //倒计时状态下的颜色
    UIColor *countColor = [UIColor lightGrayColor];
    [self setTheCountdownButton:sender startWithTime:10 title:@"获取验证码" countDownTitle:@"s" mainColor:mainColor countColor:countColor];
}

//下一步
- (IBAction)nextButtonTap:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"绑定成功" message:@"zhoubo" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        DBLog(@"点击了取消");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        DBLog(@"点击了确定");
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
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

@end
