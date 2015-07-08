//
//  LQMapView.m
//  自定义定位地图
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import "LQMapView.h"

@interface LQMapView()<UIScrollViewDelegate>

@end

@implementation LQMapView

+ (instancetype)mapView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIImageView *mapImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"222.png"]];
        mapImageView.userInteractionEnabled = YES;
        self.mapImageView = mapImageView;
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        [self loadingViewWithMapImageView:mapImageView];
    }
    
    return self;
}

- (void)loadingViewWithMapImageView:(UIImageView *)mapImageView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.frame;
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 5.0;
    scrollView.zoomScale = 1.0;
    scrollView.bouncesZoom = NO;
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(mapImageView.frame), CGRectGetHeight(mapImageView.frame));
    [scrollView addSubview:mapImageView];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMapImageVew)];
    [self.mapImageView addGestureRecognizer:tap];
}

/**
 *  点击了地图
 */
- (void)tapMapImageVew
{
    if ([self.delegate respondsToSelector:@selector(mapViewDidTapMapImageViewWithView:)]) {
        [self.delegate mapViewDidTapMapImageViewWithView:self];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.mapImageView.image = [UIImage imageNamed:@"222.png"];
    
    if ([self.delegate respondsToSelector:@selector(mapViewDidZoomingWithView:zoomScale:)]) {
        [self.delegate mapViewDidZoomingWithView:self zoomScale:scrollView.zoomScale];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.delegate respondsToSelector:@selector(mapViewDidEndZoomingWithView:zoomScale:)]) {
        [self.delegate mapViewDidEndZoomingWithView:self zoomScale:scale];
    }
}

@end
