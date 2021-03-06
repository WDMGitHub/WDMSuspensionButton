//
//  MeetingAnimation.h
//  botong
//
//  Created by demin on 16/7/13.
//  Copyright © 2016年 Demin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTCButton.h"

@interface MeetingAnimation : UIView

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

//悬浮按钮
@property (strong, nonatomic) RTCButton *microBtn;

//单例模式
+ (instancetype)SharedMeetingAnimation;

//弹出电话会议界面的动画
- (void)popMeetingViewAnimationWithView:(UIView *)MeetingView andFirstButton:(UIButton *)iconButton andSecondButton:(UIButton *)overButton  andthirdButton:(UIButton *)MinButton;
//最小化界面的动画
- (void)minimizingViewAniamtion;
//点击悬浮按钮放大界面的动画
- (void)microClick;
//会议结束的动画
- (void)meetingViewDismissAniation;
//移除电话会议界面
- (void)meetingViewDismiss;

@end
