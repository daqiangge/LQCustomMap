//
//  LQSoundButton.h
//  自定义定位地图
//
//  Created by admin on 15/7/11.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQSoundButton;

@protocol LQSoundButtonDelegate<NSObject>

- (void)soundBtnDidClickWithView:(LQSoundButton *)soundButton;

@end


@interface LQSoundButton : UIView

@property (nonatomic, weak) id<LQSoundButtonDelegate> delegate;


+ (instancetype)soundButtonWithFrame:(CGRect)frame;
- (void)startSoundButton:(UIButton *)button;
- (void)stopSoundButton:(UIButton *)button;

@end
