//
//  LQLocationView.m
//  自定义定位地图
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import "LQLocationView.h"

@implementation LQLocationView

+ (instancetype)locationViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        arrow.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:arrow];
        
        GeoPointCompass *geoPointCompass = [[GeoPointCompass alloc] init];
        self.geoPointCompass = geoPointCompass;
        [self.geoPointCompass setArrowImageView:arrow];
        
        
//        self.layer.cornerRadius = 10.0;
//        self.backgroundColor = [UIColor redColor];
        
//        UIView *smallView = [[UIView alloc] init];
//        smallView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)-4, CGRectGetHeight(self.frame)-4);
//        smallView.center = CGPointMake(self.center.x, self.center.y);
//        smallView.backgroundColor = [UIColor blueColor];
//        smallView.layer.cornerRadius = 8.0;
//        [self addSubview:smallView];
    }
    
    return self;
}

@end
