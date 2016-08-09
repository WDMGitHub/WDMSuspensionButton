//
//  MeetingAnimation.m
//  botong
//
//  Created by demin on 16/7/13.
//  Copyright © 2016年 Demin. All rights reserved.
//

#import "MeetingAnimation.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation MeetingAnimation

{
    UIView *_meetView;
    UIButton *_iconBtn;
    UIButton *_overBtn;
    UIButton *_MinBtn;
}

+ (instancetype)SharedMeetingAnimation {
    static MeetingAnimation *sharedMeetingAnimation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMeetingAnimation = [[self alloc] init];
    });
    return sharedMeetingAnimation;
}

//弹出电话会议界面的动画
- (void)popMeetingViewAnimationWithView:(UIView *)MeetingView andFirstButton:(UIButton *)iconButton andSecondButton:(UIButton *)overButton andthirdButton:(UIButton *)MinButton {
    
    _meetView = MeetingView;
    _iconBtn = iconButton;
    _overBtn = overButton;
    _MinBtn = MinButton;
    _iconBtn.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(_iconBtn.frame));
    _overBtn.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(_overBtn.frame));
    _meetView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:_meetView];
    [UIView animateWithDuration:0.5 animations:^{
        _meetView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _iconBtn.transform = CGAffineTransformIdentity;
            _overBtn.transform = CGAffineTransformIdentity;
        }];
    }];
}

//最小化界面的动画
- (void)minimizingViewAniamtion {
    
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:_iconBtn.frame];
    // 2.获取动画缩放开始时的圆形
    CGSize startSize = CGSizeMake(_meetView.frame.size.width * 0.5, _meetView.frame.size.height - _iconBtn.center.y);
    CGFloat radius = sqrt(startSize.width * startSize.width + startSize.height * startSize.height);
    CGRect startRect = CGRectInset(_iconBtn.frame, -radius, -radius);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    
    // 3.创建shapeLayer作为视图的遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = endPath.CGPath;
    _meetView.layer.mask = shapeLayer;
    self.shapeLayer = shapeLayer;
    
    // 添加动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)startPath.CGPath;
    pathAnimation.toValue = (id)endPath.CGPath;
    pathAnimation.duration = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.delegate = self;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    
    [shapeLayer addAnimation:pathAnimation forKey:@"packupAnimation"];
}

//最小化界面的二次动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  
    if ([anim isEqual:[self.shapeLayer animationForKey:@"packupAnimation"]]) {
        CGRect rect = _meetView.frame;
        rect.origin = _iconBtn.frame.origin;
        _meetView.bounds = rect;
        rect.size = _iconBtn.frame.size;
        _meetView.frame = rect;
        
        self.microBtn.frame = _meetView.frame;
        self.microBtn.layer.cornerRadius = self.microBtn.bounds.size.width * 0.5;
        self.microBtn.layer.masksToBounds = YES;
        [_meetView.superview addSubview:_microBtn];

        [UIView animateWithDuration:0.5 animations:^{
            _meetView.center = CGPointMake(SCREEN_WIDTH-_iconBtn.frame.size.width/2, _iconBtn.frame.size.height*2);
            
            self.microBtn.center = CGPointMake(SCREEN_WIDTH-_iconBtn.frame.size.width/2, _iconBtn.frame.size.height*2);
            self.microBtn.transform = CGAffineTransformMakeScale(1, 1);
            _meetView.transform = CGAffineTransformMakeScale(1, 1);
            
        } completion:^(BOOL finished) {
            
            _meetView.hidden = YES;
        }];
        
    } else if ([anim isEqual:[self.shapeLayer animationForKey:@"showAnimation"]]) {
        _meetView.layer.mask = nil;
        self.shapeLayer = nil;
    }
}

- (RTCButton *)microBtn
{
    if (!_microBtn) {
        _microBtn = [[RTCButton alloc] initWithTitle:@"" noHandleImageName:@""];
        
        UIImage *image = [UIImage imageNamed:@"metting_icon_hoveringBtn"];
        CGFloat top = 0; // 顶端盖高度
        CGFloat bottom = 0 ; // 底端盖高度
        CGFloat left = 0; // 左端盖宽度
        CGFloat right = 0; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        //    UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
        //    UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
        [_microBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_microBtn setBackgroundImage:image forState:UIControlStateSelected];
        [_microBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_microBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_microBtn setDragEnable:YES];
        [_microBtn setAdsorbEnable:YES];
        _microBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _microBtn.backgroundColor = [UIColor colorWithRed:253/255.0 green:174/255.0 blue:126/255.0 alpha:1];
        [_microBtn addTarget:self action:@selector(microClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _microBtn;
}

//点击悬浮按钮放大界面的动画
- (void)microClick {
    //关闭按钮的吸附效果，否则动画失败
    _microBtn.adsorbEnable = NO;
    
    //点击悬浮按钮关闭跳转按钮的通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"ClickMicroButton" object:nil];

    _meetView.frame = self.microBtn.frame;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _meetView.center = CGPointMake(SCREEN_WIDTH/2, _iconBtn.frame.size.height*2);
        _microBtn.center = CGPointMake(SCREEN_WIDTH/2, _iconBtn.frame.size.height*2);
        
    } completion:^(BOOL finished) {
        
        _meetView.hidden = NO;
        [self.microBtn removeFromSuperview];
        self.microBtn = nil;
        
        _meetView.bounds = [UIScreen mainScreen].bounds;
        _meetView.frame = _meetView.bounds;
        
        CAShapeLayer *shapeLayer = self.shapeLayer;
        
        // 1.获取动画缩放开始时的圆形
        UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:_iconBtn.frame];
        
        // 2.获取动画缩放结束时的圆形
        CGSize endSize = CGSizeMake(_meetView.frame.size.width * 0.5, _meetView.frame.size.height - _iconBtn.center.y);
        CGFloat radius = sqrt(endSize.width * endSize.width + endSize.height * endSize.height);
        CGRect endRect = CGRectInset(_iconBtn.frame, -radius, -radius);
        UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
        
        // 3.创建shapeLayer作为视图的遮罩
        shapeLayer.path = endPath.CGPath;
        
        // 添加动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (id)startPath.CGPath;
        pathAnimation.toValue = (id)endPath.CGPath;
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.delegate = self;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.fillMode = kCAFillModeForwards;
        
        [shapeLayer addAnimation:pathAnimation forKey:@"showAnimation"];
    }];
    _MinBtn.enabled = YES;
}

//会议结束的动画
- (void)meetingViewDismissAniation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        _iconBtn.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(_iconBtn.frame));
        _overBtn.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(_overBtn.frame));
    } completion:^(BOOL finished) {
        self.alpha = 0;
        [_meetView removeFromSuperview];
    }];
}

//移除电话会议界面
- (void)meetingViewDismiss {
    [_meetView removeFromSuperview];
}




@end
