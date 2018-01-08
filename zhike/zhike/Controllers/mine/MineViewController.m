//
//  MineViewController.m
//  zhike
//
//  Created by 周博 on 2017/11/24.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "MineViewController.h"
#import "HomeViewController.h"

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
