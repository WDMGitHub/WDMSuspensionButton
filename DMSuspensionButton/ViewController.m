//
//  ViewController.m
//  DMSuspensionButton
//
//  Created by demin on 16/8/9.
//  Copyright © 2016年 Demin. All rights reserved.
//

#import "ViewController.h"
#import "PhoneMeetingView.h"
#import "MeetingAnimation.h"

@interface ViewController ()<PhoneMeetingViewDelegate>
@property (nonatomic, strong) PhoneMeetingView * popMeetingView;
@property (nonatomic, strong) MeetingAnimation *meetingAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(setEnabledIsYES) name:@"ClickMinButton" object:nil];
    [center addObserver:self selector:@selector(setEnabledIsNO) name:@"ClickMicroButton" object:nil];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setEnabledIsYES {
    self.jumpBtn.enabled = YES;
}

- (void)setEnabledIsNO {
    self.jumpBtn.enabled = NO;
}

- (IBAction)clickBtn:(id)sender {
    self.jumpBtn.enabled = NO;
    if (self.popMeetingView == nil) {
        self.popMeetingView = [[[NSBundle bundleForClass:[PhoneMeetingView class]] loadNibNamed:NSStringFromClass([PhoneMeetingView class]) owner:nil options:nil] lastObject];
        self.popMeetingView.delegate = self;
        self.popMeetingView.frame = self.view.bounds;
        [self.view addSubview:self.popMeetingView];
        [self.popMeetingView popMeetingView];
    }else {
        self.meetingAnimation = [MeetingAnimation SharedMeetingAnimation];
        [self.meetingAnimation microClick];
    }
    __weak typeof(self) weakself = self;
    self.popMeetingView.Enabledblock = ^(NSString *string){
        weakself.jumpBtn.enabled = string;
    };

}
- (void)MeetingDismissClick {
    self.popMeetingView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
