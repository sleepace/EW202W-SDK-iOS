//
//  SLPMinutePicker.h
//  Sleepace
//
//  Created by Shawley on 7/27/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SLPMinutePickerMode) {
    SLPMinutePickerMode_Hour = 0, //小时模式，间隔1小时
    SLPMinutePickerMode_Minute, //分钟模式，间隔15分钟
    SLPMinutePickerMode_Second, //秒钟模式，间隔15秒钟
    SLPMinutePickerMode_TimeFormat,//时间制式
};

typedef NS_ENUM(NSInteger, SLPPickerValue) {
    SLPPickerValue_Fifteen = 0,
    SLPPickerValue_Thirty,
    SLPPickerValue_FortyFive,
    SLPPickerValue_Sixty,
};

#ifdef SLP_ASSIST_TEST
static const NSInteger g_secondOrignal = 1;
static const NSInteger g_minuteOrignal = 1;
static const NSInteger g_hourOrignal = 1;
#else
static const NSInteger g_secondOrignal = 1;
static const NSInteger g_minuteOrignal = 15;
static const NSInteger g_hourOrignal = 1;
#endif


@class SLPMinutePicker;

@protocol SLPMinutePickerDelegate <NSObject>

@optional
- (void)slpMinutePickerValueChanged:(SLPMinutePicker *)pickerView;
- (CGFloat)slpMinutePicker:(SLPMinutePicker *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)slpMinutePicker:(SLPMinutePicker *)pickerView rowHeightForComponent:(NSInteger)component;

- (UIFont *)slpMinutePicker:(SLPMinutePicker *)pickerView titleFontForRow:(NSInteger)row forComponent:(NSInteger)component;
- (UIColor *)slpMinutePicker:(SLPMinutePicker *)pickerView titleColorForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

@interface SLPMinutePicker : UIView

@property (nonatomic,weak) id<SLPMinutePickerDelegate> delegate;
@property (nonatomic,assign)SLPMinutePickerMode mode;
@property (nonatomic,readonly,assign) NSInteger time;
@property (nonatomic,strong) NSArray *iValues;//选项 正整数

- (void)setSelectedValue:(NSInteger)value;
@end
