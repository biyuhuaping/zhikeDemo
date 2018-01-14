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
    if ([self.btn.titleLabel.text isEqualToString:@"关注"]) {
        [_btn setTitle:@"已关注" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btn.layer.borderColor = [UIColor clearColor].CGColor;
    }else if ([self.btn.titleLabel.text isEqualToString:@"已关注"]){
        [_btn setTitle:@"关注" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _btn.layer.borderWidth = 1;
        _btn.layer.cornerRadius = 4;
        _btn.layer.borderColor = [UIColor redColor].CGColor;
    }
}

@end
