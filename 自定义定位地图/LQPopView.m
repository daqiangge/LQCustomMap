//
//  LQPopView.m
//  自定义定位地图
//
//  Created by admin on 15/7/8.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import "LQPopView.h"

@implementation LQPopView

+ (instancetype)popViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1111"]];
    imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:imageView];
}

@end
