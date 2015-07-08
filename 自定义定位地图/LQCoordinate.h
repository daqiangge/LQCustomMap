//
//  LQCoordinate.h
//  自定义定位地图
//
//  Created by admin on 15/7/8.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQCoordinate : NSObject

@property (nonatomic, strong) NSArray *latitudeAndLongitudeArray;

@end

@interface LatitudeAndLongitude : NSObject

/**
 *  纬度----Y轴
 */
@property (nonatomic, assign) double latitude;

/**
 *  经度----X轴
 */
@property (nonatomic, assign) double longitude;

@end
