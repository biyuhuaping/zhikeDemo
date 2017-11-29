//
//  BaseTabBarController.m
//  zhike
//
//  Created by 周博 on 2017/11/24.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabbarItems {
    NSArray *tabbarTitleArray = @[@"最新投资",
                                  @"债权转让",
                                  @"豆哥商城",
                                  @"个人中心"];
    NSArray *tabbarNormalArray = @[@"tabbar_icon_project_normal.png",
                                   @"tabbar_icon_transfer_normal.png",
                                   @"tabbar_icon_shop_normal.png",
                                   @"tabbar_icon_user_normal.png"];
    NSArray *tabbarHighlightArray = @[@"tabbar_icon_project_highlight.png",
                                      @"tabbar_icon_transfer_highlight.png",
                                      @"tabbar_icon_shop_highlight.png",
                                      @"tabbar_icon_user_highlight.png"];

    HomeViewController *home = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    home.title = @"首页";
    home.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabbarTitleArray[0] image:[[UIImage imageNamed:tabbarNormalArray[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:tabbarHighlightArray[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *nav0 = [[BaseNavigationController alloc]initWithRootViewController:home];

    QuestionViewController *question = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    question.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabbarTitleArray[1] image:[[UIImage imageNamed:tabbarNormalArray[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:tabbarHighlightArray[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *nav1 = [[BaseNavigationController alloc]initWithRootViewController:question];

    MineViewController *min = [[MineViewController alloc]initWithNibName:@"MineViewController" bundle:nil];
    min.title = @"我的";
    min.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabbarTitleArray[2] image:[[UIImage imageNamed:tabbarNormalArray[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:tabbarHighlightArray[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *nav2 = [[BaseNavigationController alloc]initWithRootViewController:min];
    self.viewControllers = @[nav0,nav1,nav2];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
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
}

@end
