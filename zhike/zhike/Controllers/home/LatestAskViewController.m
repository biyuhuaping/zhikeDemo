//
//  LatestAskViewController.m
//  zhike
//
//  Created by 周博 on 2017/12/20.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "LatestAskViewController.h"
#import "TableViewCell1.h"

@interface LatestAskViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataListArry;

@end

@implementation LatestAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataListArry = [NSMutableArray new];

    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView
//设置区域的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;//self.dataListArry.count;
}
//返回单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TableViewCell1";
    TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TableViewCell1" owner:self options:nil][0];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"分组1-%ld",indexPath.row];
    return cell;
}


@end
