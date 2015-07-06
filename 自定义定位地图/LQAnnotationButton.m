//
//  LQAnnotationButton.m
//  自定义定位地图
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import "LQAnnotationButton.h"

@implementation LQAnnotationButton

+ (instancetype)annotationButton
{
    CGRect frame = CGRectMake(-100, 0, 50, 20);
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

@end
