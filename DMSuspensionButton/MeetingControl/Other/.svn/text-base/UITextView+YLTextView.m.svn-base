//
//  UITextView+YLTextView.m
//  Dangdang
//
//  Created by demin on 16/7/6.
//  Copyright © 2016年 BoTong. All rights reserved.
//

#import "UITextView+YLTextView.h"
#import "objc/runtime.h"    

static const void *limitLengthKey = &limitLengthKey;

@implementation UITextView (YLTextView)

- (NSNumber *)limitLength {
    return objc_getAssociatedObject(self, limitLengthKey);
}

- (void)setLimitLength:(NSNumber *)limitLength {
    objc_setAssociatedObject(self, limitLengthKey, limitLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addLimitLengthObserver:[limitLength intValue]];
}

//  增加限制位数的通知
- (void)addLimitLengthObserver:(int)length {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitLengthEvent) name:UITextViewTextDidChangeNotification object:self];
}

//  限制输入的位数
- (void)limitLengthEvent {
    if ([self.text length] > [self.limitLength intValue]) {
        self.text = [self.text substringToIndex:[self.limitLength intValue]];
    }
}




@end
