//
//  LQMapView.h
//  自定义定位地图
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQMapView;

@protocol LQMapViewDelegate <NSObject>

- (void)mapViewDidZoomingWithView:(LQMapView *)view zoomScale:(CGFloat)scale;
- (void)mapViewDidEndZoomingWithView:(LQMapView *)view zoomScale:(CGFloat)scale;
- (void)mapViewDidTapMapImageViewWithView:(LQMapView *)view;

@end

@interface LQMapView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *mapImageView;
@property (nonatomic, weak) id<LQMapViewDelegate> delegate;

+ (instancetype)mapView;

@end
