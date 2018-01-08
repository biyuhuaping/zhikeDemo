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
#import <SDCycleScrollView.h>

#import "SearchViewController.h"
#import "TableViewCell1.h"
#import "TableViewCell2.h"

#import "ZBNetworkManager.h"

#import "User.h"
#import "RegisterModel.h"

#import "LatestAskViewController.h"
#import "TeacherRecommendVC.h"

@interface HomeViewController ()<UISearchControllerDelegate,UISearchBarDelegate,SDCycleScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataListArry;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) SearchViewController *searchVC;


@property (strong, nonatomic) NSMutableArray *banderImgArray;


//导师、快问、精选 View
@property (strong, nonatomic) IBOutlet UIView *subView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;//不加的话，table会下移
    self.edgesForExtendedLayout = UIRectEdgeNone;//不加的话，UISearchBar返回后会上移

    self.dataListArry = [NSMutableArray new];
    self.banderImgArray = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 1; i<7; i++) {
        NSString *str = [NSString stringWithFormat:@"cycle_image%d",i];
        [self.banderImgArray addObject:[UIImage imageNamed:str]];
    }
    
    [self initSearchController];
    
    
    //设置tebleView
//    iOS11之后searchController有了新样式，可以放在导航栏
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

//    self.tableView.estimatedRowHeight = 75;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
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

    self.definesPresentationContext = YES;// 如果进入预编辑状态,searchBar消失
}

- (IBAction)subViewButtonAction:(UIButton *)sender {
    NSLog(@"点击了按钮");
}

//点击查看更多 push 到对应页面
- (void)nextViewController:(UIButton *)sender{
    if (sender.tag == 10) {
        LatestAskViewController *latestVC = [[LatestAskViewController alloc]initWithNibName:@"LatestAskViewController" bundle:nil];
        [self.navigationController pushViewController:latestVC animated:YES];
    }else{
        TeacherRecommendVC *teacherVC = [[TeacherRecommendVC alloc]initWithNibName:@"TeacherRecommendVC" bundle:nil];
        [self.navigationController pushViewController:teacherVC animated:YES];
    }
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return kScreenWidth*9/16 + CGRectGetHeight(self.subView.frame);
        }
            break;
        case 1:{
            return 150;
        }
            break;
        case 2:{
            return 75;
        }
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;//3组
}

//设置区域的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 2;
        }
            break;
        case 2:{
            return 10;
        }
            break;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)] ;
    customView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200.0, 44)] ;
    headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    [customView addSubview:headerLabel];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kScreenWidth-80, 0, 80, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
//    button.backgroundColor = [UIColor redColor];
    [button setTitle:@" 看更多 >" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextViewController:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button];
    
    switch (section) {
        case 0:{
            return nil;
        }
            break;
        case 1:{
            headerLabel.text = @"最新提问";
            button.tag = 10;
        }
            break;
        case 2:{
            headerLabel.text = @"名师推荐";
        }
            break;
    }
    return customView;
}

//返回单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{//banner
            static NSString *identifier = @"cell1";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if (indexPath.row == 0) {
                float hight = kScreenWidth*9/16;
                // 本地加载图片的轮播器
                SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, hight) imageNamesGroup:self.banderImgArray];
                bannerView.delegate = self;
                bannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
                [cell.contentView addSubview:bannerView];
                
                self.subView.frame = CGRectMake(0, hight, kScreenWidth, CGRectGetHeight(self.subView.frame));
                [cell.contentView addSubview:self.subView];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
        case 1:{//分组1
            static NSString *identifier = @"cell2";
            TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TableViewCell1" owner:self options:nil][0];
            }
//            cell.textLabel.text = [NSString stringWithFormat:@"分组1-%ld",indexPath.row];
            return cell;
        }
        case 2:{//分组2
            static NSString *identifier = @"cell3";
            TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TableViewCell2" owner:self options:nil][0];
            }
//            cell.textLabel.text = [NSString stringWithFormat:@"分组2-%ld",indexPath.row];
            return cell;
        }
    }
    return nil;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    NSLog(@"---点击了第%ld张图片", (long)index);
//    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
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
    [ZBNetworking getWithUrl:url cache:NO params:nil progressBlock:^(int64_t bytesRead, int64_t totalBytes) {
        NSLog(@"%lld--%lld",bytesRead,totalBytes);
//        [NSThread sleepForTimeInterval:5];
    } successBlock:^(id response) {
        //        NSLog(@"%@",response);
        User *user = [User mj_objectWithKeyValues:response];
        DBLOG(@"%@,%@",user.stories[0][@"title"],user.stories[0][@"id"]);
    } failBlock:^(NSError *error) {
//        DBLOG(@"%@",error);
    }];
    NSLog(@"缓存size is %lu",(unsigned long)[ZBNetworking totalCacheSize]);
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
