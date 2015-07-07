//
//  LQScenics.h
//  自定义定位地图
//
//  Created by admin on 15/7/7.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQScenics : NSObject

@property (nonatomic, strong) NSArray *scenics;

@end

@interface Scenics : NSObject

/**
 *  纬度----Y轴
 */
@property (nonatomic, assign) double latitude;

/**
 *  经度----X轴
 */
@property (nonatomic, assign) double longgitude;

@end