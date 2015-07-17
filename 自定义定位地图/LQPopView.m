//
//  LQPopView.m
//  自定义定位地图
//
//  Created by admin on 15/7/8.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import "LQPopView.h"
#import "LQSoundButton.h"

@interface LQPopView()<LQSoundButtonDelegate>

@end

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
    
    LQSoundButton *soundBtn = [LQSoundButton soundButtonWithFrame:CGRectMake(10, 30, 40, 30)];
    soundBtn.delegate = self;
    [self addSubview:soundBtn];
    
    soundBtn.layer.borderColor = [UIColor blackColor].CGColor;
    soundBtn.layer.borderWidth = 1.0;
    soundBtn.layer.cornerRadius = 3.0;
    
    UIButton *detailsBtn = [[UIButton alloc] init];
    detailsBtn.frame = CGRectMake(CGRectGetMaxX(soundBtn.frame)+20, CGRectGetMinY(soundBtn.frame), CGRectGetWidth(soundBtn.frame), CGRectGetHeight(soundBtn.frame));
    [detailsBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detailsBtn addTarget:self action:@selector(touchDetailsBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailsBtn];
    
    detailsBtn.layer.borderColor = [UIColor blackColor].CGColor;
    detailsBtn.layer.borderWidth = 1.0;
    detailsBtn.layer.cornerRadius = 3.0;
    
}

- (void)touchDetailsBtn
{
    if ([self.delegate respondsToSelector:@selector(popViewDidTouchDetailsBtnWithView:) ]) {
        [self.delegate popViewDidTouchDetailsBtnWithView:self];
    }
}

#pragma mark - LQSoundButtonDelegate
- (void)soundBtnDidClickWithView:(LQSoundButton *)soundButton
{
    if ([self.delegate respondsToSelector:@selector(popViewDidClickSoundBtnWithView:soundButton:) ]) {
        [self.delegate popViewDidClickSoundBtnWithView:self soundButton:soundButton];
    }
}

@end
