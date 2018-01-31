//
//  BaseTabBarController.m
//  zhike
//
//  Created by 周博 on 2017/11/24.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "BaseTabBarController.h"
#import "ZBTabBar.h"
#import "AppDelegate.h"

#import "HomeViewController.h"
#import "QuestionViewController.h"
#import "MineViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化viewControllers
    [self initTabbarItems];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabbarItems {
    NSArray *imageArray = @[@"tabbar_icon_project_normal.png", @"tabbar_icon_transfer_normal.png", @"tabbar_icon_shop_normal.png", @"tabbar_icon_user_normal.png"];
    NSArray *selectedImageArray = @[@"tabbar_icon_project_highlight.png", @"tabbar_icon_transfer_highlight.png", @"tabbar_icon_shop_highlight.png", @"tabbar_icon_user_highlight.png"];

    HomeViewController *home = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [self addChildViewController:home title:@"首页" imageNamed:imageArray[0] selectedImageName:selectedImageArray[0]];
    
    [self addCustomtabbar];

    MineViewController *min = [[MineViewController alloc]initWithNibName:@"MineViewController" bundle:nil];
    [self addChildViewController:min title:@"我的" imageNamed:imageArray[2] selectedImageName:selectedImageArray[2]];

    
    //统一设置（选中/未选中）文字颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor redColor] } forState:UIControlStateSelected];
}

// 添加某个 childViewController
- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageNamed selectedImageName:(NSString*)selectedImageName {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    // 如果同时有navigationbar 和 tabbar的时候最好分别设置它们的title
    vc.navigationItem.title = title;
    nav.tabBarItem.title = title;
    
    nav.tabBarItem.image = [[UIImage imageNamed:imageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 单独设置选中tabbar文字颜色
//    [vc.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] } forState:UIControlStateSelected];
    
    [self addChildViewController:nav];
}

- (void)addCustomtabbar{
    ZBTabBar *tabbar = [[ZBTabBar alloc]init];
    [self setValue:tabbar forKeyPath:@"tabBar"];
    [tabbar.centerTabBar addTarget:self action:@selector(centerTabBarClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)centerTabBarClick:(UIButton *)btn{
    NSLog(@"点击了中间");
    //果冻动画
    CAKeyframeAnimation *kf = [[CAKeyframeAnimation alloc]init];
    [kf setKeyPath:@"transform.scale"];
    kf.values = @[@1.0, @0.7, @0.5, @0.3, @0.5, @0.7, @1.0, @1.2, @1.4, @1.2, @1.0];
    kf.keyTimes = @[@0.0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1.0];
    kf.duration = 0.2;
    [btn.layer addAnimation:kf forKey:@"Show"];
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"点击了中间按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
    QuestionViewController *question = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:question];
    question.title = @"问吧";
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITabBarControllerDelegate
/**
 *  点击Item时调用：控制哪些 ViewController 的标签栏能被点击
 *  @return YES:允许点击 NO:不允许点击
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

/**
 *  点击Item时调用
 *  @param viewController   将要点击的目标控制器
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"%ld",self.selectedIndex);
    if (self.selectedIndex == 1){
        if (1){
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate showTabbarController];
//            [tabBarController setSelectedIndex:0];
        }
    }
}

@end
