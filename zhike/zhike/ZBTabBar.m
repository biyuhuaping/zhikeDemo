//
//  ZBTabBar.m
//  zhike
//
//  Created by 周博 on 2017/12/1.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBTabBar.h"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation ZBTabBar

- (instancetype)init{
    self = [super init];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"plus_Last"] forState:UIControlStateNormal];
        btn.bounds = CGRectMake(0, 0, 64, 64);
        self.centerTabBar = btn;
        [self addSubview:btn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //去掉TabBar上部的横线
    for (UIView *view in self.subviews){
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1){   //横线的高度为0.5
            UIImageView *line = (UIImageView *)view;
            line.hidden = YES;
        }
    }
    
    
    self.centerTabBar.center = CGPointMake(CGRectGetMaxX(self.bounds) * 0.5, 10);
    int index = 0;
    CGFloat width = CGRectGetMaxX(self.bounds) / 3;//共有几个tabbar就除以几
    CGFloat hightOffset = 0;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            //如果到自定义的tabbar，就index++ 跳过，留位置
            if (index == 1) {
                index++;
            }
            NSLog(@"----:%f",CGRectGetMaxY(self.bounds));
            if (iPhoneX) { //iPhone X 的tabbar是 83，所以需要 -34
                hightOffset = 34;
            }
            subView.frame = CGRectMake(index * width, CGRectGetMinY(self.bounds), width, CGRectGetMaxY(self.bounds) - hightOffset);//iPhone X 需要-34
            index ++;
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {//这一个判断是关键，不判断的话push到其他页面，点击“+”按钮的位置也是会有反应
        CGPoint newPoint = [self convertPoint:point toView:self.centerTabBar];
        if ([self.centerTabBar pointInside:newPoint withEvent:event]) {
            return self.centerTabBar;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
