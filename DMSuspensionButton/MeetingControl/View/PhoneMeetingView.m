//
//  PhoneMeetingView.m
//  botong
//
//  Created by demin on 16/7/12.
//  Copyright © 2016年 Demin. All rights reserved.
//

#import "PhoneMeetingView.h"
#import "MemberIconsCollectionViewCell.h"
#import "MemberPassCell.h"  
#import "YLPopViewController.h"
#import "MeetingAnimation.h"    

@interface PhoneMeetingView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end


@implementation PhoneMeetingView

- (void)awakeFromNib {
    self.backgroundColor = [UIColor lightGrayColor];
    [self addSubViews];
}

- (void)addSubViews {
    self.backgroundColor = [UIColor blackColor];
    self.overButton.layer.cornerRadius = self.overButton.frame.size.height/2;
    self.iconButton.layer.cornerRadius = self.iconButton.frame.size.height/2;
    self.iconButton.layer.masksToBounds = YES;
    
    self.memberPassDetailsTableView.delegate = self;
    self.memberPassDetailsTableView.dataSource = self;
    [self.memberPassDetailsTableView registerNib:[UINib nibWithNibName:@"MemberPassCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"passCell"];
    
    self.memberIconsCollectionView.delegate = self;
    self.memberIconsCollectionView.dataSource = self;
    [self.memberIconsCollectionView registerNib:[UINib nibWithNibName:@"MemberIconsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MemberCollectionCell"];
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberPassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"passCell"];
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.passDetailLabel.text = @"会议开始";
    cell.passTimeLabel.text = @"10:21";
    return cell;
}

#pragma mark - collectionView delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(71, 69);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberIconsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberCollectionCell" forIndexPath:indexPath];
    cell.iconImageView.layer.cornerRadius = 22.0f;
    cell.iconImageView.layer.masksToBounds = YES;
    cell.iconTitleLabel.text = @"路飞";
    return cell;
}

//最小化界面
- (IBAction)clickMinButton:(id)sender {
    [self.MeetAnimation minimizingViewAniamtion];
    
    self.MinButton.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //最小化界面的通知
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"ClickMinButton" object:nil];
    });

}

//添加成员
- (IBAction)addMembers:(id)sender {
    
}

//会议纪要
- (IBAction)clickMinutesButton:(id)sender {
    YLPopViewController *popView = [[YLPopViewController alloc] init];
    popView.contentViewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-40, 210);
    popView.Title = @"会议纪要";
    popView.placeHolder = @"请在此输入内容...";
    popView.wordCount = 150;//不设置则没有
    [popView addContentView];//最后调用
    popView.confirmBlock = ^(NSString *text) {
        
    };    
}

//会议结束
-(IBAction)quitMeetingClick:(id)sender
{
    [self.MeetAnimation meetingViewDismissAniation];
    [self.delegate MeetingDismissClick];
    self.Enabledblock(@"YES");
}

- (void)popMeetingView {
    self.MeetAnimation = [MeetingAnimation SharedMeetingAnimation];
    [self.MeetAnimation popMeetingViewAnimationWithView:self andFirstButton:self.iconButton andSecondButton:self.overButton andthirdButton:self.MinButton
     ];
}



@end
