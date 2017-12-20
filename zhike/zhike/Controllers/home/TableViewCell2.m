//
//  TableViewCell2.m
//  zhike
//
//  Created by 周博 on 2017/12/16.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "TableViewCell2.h"

@implementation TableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btn.layer.borderWidth = 1;
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followButton:(id)sender {
    NSLog(@"点击了关注按钮");
}
@end
