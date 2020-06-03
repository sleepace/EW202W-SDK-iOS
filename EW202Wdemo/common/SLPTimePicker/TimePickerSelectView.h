//
//  TimePickerSelectView.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/19.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLPTimePicker.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinishSelectTimeBlock)(SLPTime24 *time24);
typedef void(^CancelSelectTimeBlock)(void);

@interface TimePickerSelectView : UIView

+ (TimePickerSelectView *)timePickerSelectView;

- (void)showInView:(UIView *)view mode:(SLPTimePickerMode)mode time:(SLPTime24 *)time finishHandle:(FinishSelectTimeBlock)finishHandle cancelHandle:(CancelSelectTimeBlock)cancelHandle;

@end

NS_ASSUME_NONNULL_END
