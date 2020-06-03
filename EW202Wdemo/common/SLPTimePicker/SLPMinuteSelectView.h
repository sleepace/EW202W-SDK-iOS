//
//  SLPMinuteSelectView.h
//  Sleepace
//
//  Created by Shawley on 7/27/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLPMinutePicker.h"

#ifdef SLP_ASSIST_TEST
static const NSInteger customMinuteInteral = 2;
static const NSInteger defaultMinuteInteral = 2;
#else
static const NSInteger customMinuteInteral = 5;
static const NSInteger defaultMinuteInteral = 15;
#endif


typedef void(^FinishBtnTappedBlock)(NSInteger timeValue);
typedef void(^CancelBtnTappedBlock)(void);

@interface SLPMinuteSelectView : UIView

+ (SLPMinuteSelectView *)minuteSelectViewWithValues:(NSArray<NSNumber *> *)iValues;//选项 正整数

- (void)showInView:(UIView *)view mode:(SLPMinutePickerMode)mode time:(NSInteger)time finishHandle:(FinishBtnTappedBlock)finishHandle cancelHandle:(CancelBtnTappedBlock)cancelHandle;

@end
