//
//  PhoneMeetingView.h
//  botong
//
//  Created by demin on 16/7/12.
//  Copyright © 2016年 Demin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTCButton.h"
@class MeetingAnimation;

//控制跳转到本界面按钮的enable状态的block
typedef void(^ButtonEnabledBlock)(NSString *);
@protocol PhoneMeetingViewDelegate <NSObject>

- (void)MeetingDismissClick;

@end

@interface PhoneMeetingView : UIView

//最小化按钮
@property (weak, nonatomic) IBOutlet UIButton *MinButton;
//添加成员
@property (weak, nonatomic) IBOutlet UIButton *addMemberButton;
//结束会议
@property (weak, nonatomic) IBOutlet UIButton *overButton;
//会议纪要
@property (weak, nonatomic) IBOutlet UIButton *minutesButton;
//全员静音
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
//主持人
@property (weak, nonatomic) IBOutlet UILabel *compereLabel;
//会议时间段
@property (weak, nonatomic) IBOutlet UILabel *mettingTimeSlot;
//会议计时
@property (weak, nonatomic) IBOutlet UILabel *mettingTimer;
//成员进出详情
@property (weak, nonatomic) IBOutlet UITableView *memberPassDetailsTableView;
//成员头像的集合视图
@property (weak, nonatomic) IBOutlet UICollectionView *memberIconsCollectionView;
//头像
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@property (nonatomic, strong) MeetingAnimation *MeetAnimation;
@property (nonatomic, strong) ButtonEnabledBlock Enabledblock;
@property (nonatomic, assign) id<PhoneMeetingViewDelegate>delegate;

- (void)popMeetingView;


@end
