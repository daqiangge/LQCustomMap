//
//  LQPopView.h
//  自定义定位地图
//
//  Created by admin on 15/7/8.
//  Copyright (c) 2015年 dieshang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LQPopView;
@class LQSoundButton;

@protocol LQPopViewDelegate <NSObject>

- (void)popViewDidClickSoundBtnWithView:(LQPopView *)popView soundButton:(LQSoundButton *)soundButton;
- (void)popViewDidTouchDetailsBtnWithView:(LQPopView *)popView;

@end


@interface LQPopView : UIView

@property (nonatomic, weak) id<LQPopViewDelegate> delegate;

+ (instancetype)popViewWithFrame:(CGRect)frame;

@end
