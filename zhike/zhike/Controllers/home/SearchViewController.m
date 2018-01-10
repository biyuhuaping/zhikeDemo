//
//  SearchViewController.m
//  zhike
//
//  Created by 周博 on 2017/12/12.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchList;//满足搜索条件的数组
@property (strong, nonatomic) NSMutableArray *dataListArry;

@property (strong, nonatomic) IBOutlet UIView *subView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchList = [NSMutableArray new];
    self.dataListArry = [NSMutableArray new];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//不加的话，table会下移
    self.edgesForExtendedLayout = UIRectEdgeNone;//不加的话，UISearchBar返回后会上移
    
    //产生100个数字+三个随机字母
    for (NSInteger i = 0; i<100; i++) {
        [self.dataListArry addObject:[NSString stringWithFormat:@"%ld%@",(long)i,[self shuffledAlphabet]]];
    }
    [self getSearchHotWord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//根据文字，排版按钮。
- (void)view:(UIView *)view makeTextButtonWithArray:(NSArray *)array{
    //然后加载到搜索页的View上。
    int x = 15;
    int y = 40;
    int interval = 10;//间隔
    int tempX = x;
    for (int i = 0; i < array.count; i ++) {
        NSString *title = array[i];//[@"keyword"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(toSearchResults:) forControlEvents:UIControlEventTouchUpInside];
        
        //setBackground
        UIImage *ima = [UIImage imageNamed:@"2-5_keywords-bg"];
        ima = [ima stretchableImageWithLeftCapWidth:3 topCapHeight:10];
        [button setBackgroundImage:ima forState:UIControlStateNormal];
        
        //setFrame
        CGFloat buttonWidth = [title boundingRectWithSize:CGSizeMake(kScreenWidth, 400) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName,nil] context:nil].size.width + 20;
        if (tempX + buttonWidth + 15 >= kScreenWidth) {
            x = 15;
            y += 40;
            tempX = 15;
        }else if (i != 0){
            x = tempX;
        }
        tempX += buttonWidth + interval;
        
        button.frame = CGRectMake(x, y, buttonWidth, 33);
        [view addSubview:button];
    }
}

//搜索热词接口
- (void)getSearchHotWord{
    NSString *url = [NSString stringWithFormat:@"%@searchhotword.php",SERVER_IP];
    DBLOG(@"请求路径：%@",url);
    
    [ZBNetworking getWithUrl:url cache:NO params:nil progressBlock:nil successBlock:^(id response) {
//        NSLog(@"%@",response);
        NSArray *data = response[@"data"];
        if (data.count == 0) {
            return;
        }
        [self view:self.subView makeTextButtonWithArray:data];
    } failBlock:^(NSError *error) {
//        DBLOG(@"%@",error);
        //测试数据
        NSArray *dataArray = @[@"王思聪",@"何洁",@"周杰伦",@"慕容晓晓",@"邓紫棋",@"小燕子",@"赵薇",@"马云",@"岳云鹏"];
        [self view:self.subView makeTextButtonWithArray:dataArray];
    }];
}

//搜索、热词
- (void)toSearchResults:(UIButton *)sender{
//    SearchResultsCtrl *searchResult = [[SearchResultsCtrl alloc]initWithNibName:@"SearchResultsCtrl" bundle:nil];
//    searchResult.keyStr = sender.titleLabel.text;//送妈妈
//    searchResult.title = sender.titleLabel.text;
//    [self.navigationController pushViewController:searchResult animated:YES];
}

#pragma mark - tableView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.searchList.count > 0 ? 44 : 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger i = self.searchList.count > 0 ? self.searchList.count : 1;
    NSLog(@"tableCell行数 = %ld",i);
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchList.count > 0) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = self.searchList[indexPath.row];
        cell.textLabel.textColor = [UIColor redColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return cell;
    }else{
        static NSString *identifier = @"subViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell.contentView addSubview:self.subView];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SearchDetailVC *vc = [[SearchDetailVC alloc]initWithNibName:@"SearchDetailVC" bundle:nil];
//    [self.nav pushViewController:vc animated:YES];
}

#pragma mark - UISearchResultsUpdating
//每输入一个字符都会执行一次
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"搜索……:%@",searchController.searchBar.text);
    searchController.searchResultsController.view.hidden = NO;

    //谓词搜索
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"self CONTAINS[c] %@", searchController.searchBar.text];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    
    //过滤数据
    self.searchList = [NSMutableArray arrayWithArray:[_dataListArry filteredArrayUsingPredicate:preicate]];
    //刷新表格
    
    [self.tableView reloadData];
}

- (void)dealloc{
    NSLog(@"searchVC");
}

@end
