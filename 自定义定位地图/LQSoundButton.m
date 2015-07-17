//
//  LQSoundButton.m
//  自定义定位地图
//
//  Created by admin on 15/7/11.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import "LQSoundButton.h"

@implementation LQSoundButton

+ (instancetype)soundButtonWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    UIButton *soundBtn = [[UIButton alloc] init];
    soundBtn.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [soundBtn setTitle:@"语音" forState:UIControlStateNormal];
    [soundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [soundBtn addTarget:self action:@selector(clickSoundBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:soundBtn];
}

- (void)clickSoundBtn:(UIButton *)button
{
    NSLog(@"点击了语音按钮");
    
    if (button.imageView.isAnimating) {
        [self stopSoundButton:button];
    }else {
        [self startSoundButton:button];
    }
    
    if ([self.delegate respondsToSelector:@selector(soundBtnDidClickWithView:)])
    {
        [self.delegate soundBtnDidClickWithView:self];
    }
}

- (void)stopSoundButton:(UIButton *)button
{
    [button.imageView stopAnimating];
    [button setImage:nil  forState:UIControlStateNormal];
    [button setTitle:@"语音" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)startSoundButton:(UIButton *)button
{
    [button setTitle:nil forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fs_icon_wave_2"]  forState:UIControlStateNormal];
    UIImage *image0 = [[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"fs_icon_wave_0"]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImage *image1 = [[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"fs_icon_wave_1"]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImage *image2 = [[UIImage imageNamed:[NSString stringWithFormat:@"%@", @"fs_icon_wave_2"]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    button.imageView.animationImages = @[image0,image1,image2];
    button.imageView.animationDuration = 1.0;
    [button.imageView startAnimating];
}

@end
