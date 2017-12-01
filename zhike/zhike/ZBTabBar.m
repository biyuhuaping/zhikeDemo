//
//  ZBTabBar.m
//  zhike
//
//  Created by 周博 on 2017/12/1.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import "ZBTabBar.h"

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
    self.centerTabBar.center = CGPointMake(CGRectGetMaxX(self.bounds) * 0.5, 10);
    int index = 0;
    CGFloat wigth = self.bounds.size.width / 3;
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            subView.frame = CGRectMake(index * wigth, CGRectGetMinY(self.bounds), wigth, CGRectGetMaxY(self.bounds)-20);
//            sub.frame = CGRectMake(index * wigth, self.bounds.origin.y, wigth, self.bounds.size.height - 2);
            index ++;
            //如果到自定义的tabbar，就index++ 跳过，留位置
            if (index == 1) {
                index++;
            }
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        CGPoint newPoint = [self convertPoint:point toView:self.centerTabBar];
        if ([self.centerTabBar pointInside:newPoint withEvent:event]) {
            return self.centerTabBar;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }
    else {
        return [super hitTest:point withEvent:event];
    }
}

@end
