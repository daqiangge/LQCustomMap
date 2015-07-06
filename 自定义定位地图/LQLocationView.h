//
//  LQLocationView.h
//  自定义定位地图
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoPointCompass.h"

@interface LQLocationView : UIView

@property (nonatomic, strong) GeoPointCompass *geoPointCompass;

+ (instancetype)locationViewWithFrame:(CGRect)frame;

@end
