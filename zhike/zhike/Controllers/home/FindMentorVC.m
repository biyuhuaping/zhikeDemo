//
//  FindMentorVC.m
//  zhike
//
//  Created by 周博 on 2018/1/9.
//  Copyright © 2018年 zhoubo. All rights reserved.
//

#import "FindMentorVC.h"
#import "TableViewCell2.h"
#import "TeacherRecommendVC.h"

@interface FindMentorVC ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) IBOutlet UIView *subView;

@end

@implementation FindMentorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找导师";
    self.dataArray = [NSMutableArray new];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//根据文字，排版按钮。
- (void)view:(UIView *)view makeTextButtonWithArray:(NSArray *)array{
    //然后加载到搜索页的View上。
    int x = 15;
    int y = 15;
    int interval = 10;//间隔
    int tempX = x;
    for (int i = 0; i < array.count; i ++) {
        NSString *title = array[i];//[@"keyword"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(toTeacherRecommendVC:) forControlEvents:UIControlEventTouchUpInside];
        
        //setBackground
        UIImage *ima = [UIImage imageNamed:@"2-5_keywords-bg"];
        ima = [ima stretchableImageWithLeftCapWidth:3 topCapHeight:10];
        [button setBackgroundImage:ima forState:UIControlStateNormal];
        
        //setFrame 因为固定安放4个按钮，所以写死宽度。
        CGFloat buttonWidth = (kScreenWidth - 60)/4;
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

//to导师列表
- (void)toTeacherRecommendVC:(UIButton *)sender{
    DBLOG(@"搜素：%@",sender.titleLabel.text);
    TeacherRecommendVC *teacherVC = [[TeacherRecommendVC alloc]initWithNibName:@"TeacherRecommendVC" bundle:nil];
    [self.navigationController pushViewController:teacherVC animated:YES];
    teacherVC.title = sender.titleLabel.text;
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 10;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return CGRectGetHeight(self.subView.frame);
        } break;
        case 1:{
            return 100;
        } break;
        case 2:{
            return 75;
        } break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;//3组
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)] ;
        customView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200.0, 44)] ;
        headerLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.font = [UIFont systemFontOfSize:14];
        [customView addSubview:headerLabel];
        headerLabel.text = @"名师推荐";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(kScreenWidth-80, 0, 80, 44);
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        //    button.backgroundColor = [UIColor redColor];
        [button setTitle:@" 看更多 >" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(toTeacherRecommendVC:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:button];
        return customView;
    }
    return nil;
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
                self.subView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.subView.frame));
                [cell.contentView addSubview:self.subView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case 1:{//分组1
                static NSString *identifier = @"cell2";
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                NSArray *dataArray = @[@"计算机类",@"管理类",@"经济学",@"艺术学",@"理学",@"工学",@"法学",@"全部"];
                [self view:cell.contentView makeTextButtonWithArray:dataArray];
                return cell;
            }
            case 2:{//分组2
                static NSString *identifier = @"cell3";
                TableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"TableViewCell2" owner:self options:nil][0];
                }
//                cell.textLabel.text = [NSString stringWithFormat:@"分组2-%ld",indexPath.row];
                return cell;
            }
    }
    return nil;
}

@end
