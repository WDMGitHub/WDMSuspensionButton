//
//  UIButton+NMCategory.h
//  DragButtonDemo
//
//  Created by Aster0id on 14-5-16.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (NMCategory)

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end
