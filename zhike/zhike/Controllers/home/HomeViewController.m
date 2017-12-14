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
#import "SearchViewController.h"

#import "User.h"
#import "RegisterModel.h"

@interface HomeViewController ()<UISearchControllerDelegate,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataListArry;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) SearchViewController *searchVC;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataListArry = [NSMutableArray new];
    self.automaticallyAdjustsScrollViewInsets = NO;//不加的话，table会下移
    self.edgesForExtendedLayout = UIRectEdgeNone;//不加的话，UISearchBar返回后会上移

    //产生100个数字+三个随机字母
    for (NSInteger i =0; i<100; i++) {
        [self.dataListArry addObject:[NSString stringWithFormat:@"%ld%@",(long)i,[self shuffledAlphabet]]];
    }
    [self initSearchController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSearchController{
    self.searchVC = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];

    //创建UISearchController
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchVC];
    self.searchController.searchResultsUpdater = self.searchVC;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.dimsBackgroundDuringPresentation = NO;//搜索时，背景变暗色
    self.searchController.searchBar.tintColor = UIColorWithRGB(0x16A101);//包着搜索框外层的颜色

    
    self.searchVC.nav = self.navigationController;
    self.searchVC.searchBar = self.searchController.searchBar;
    
    
//    iOS11之后searchController有了新样式，可以放在导航栏
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
//    self.definesPresentationContext = YES;// 如果进入预编辑状态,searchBar消失

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

//产生3个随机字母
- (NSString *)shuffledAlphabet {
    NSMutableArray * shuffledAlphabet = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    
    NSString *strTest = [[NSString alloc]init];
    for (int i=0; i<3; i++) {
        int x = arc4random() % 25;
        strTest = [NSString stringWithFormat:@"%@%@",strTest,shuffledAlphabet[x]];
    }
    return strTest;
}

#pragma mark - tableView
//设置区域的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataListArry.count;
}

//返回单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataListArry[indexPath.row];
    return cell;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    for (id obj in [searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    SearchDetailVC *vc = [[SearchDetailVC alloc]initWithNibName:@"SearchDetailVC" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    //    self.searchController.active = NO;
}

#pragma mark - UISearchControllerDelegate代理
//测试UISearchController的执行过程
- (void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"willPresentSearchController");
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    NSLog(@"willDismissSearchController");
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController {
    NSLog(@"presentSearchController");
}





































#pragma mark -
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
