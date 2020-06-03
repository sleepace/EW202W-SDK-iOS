//
//  SLPTimePicker.h
//  Profession
//
//  Created by Martin on 4/7/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLPTime24.h"

static const CGFloat kTimePickerWidth = 80.0;
static const CGFloat kTimePickerHeight = 60.0;
static const CGFloat kAMPMFont = 24.0;
static const CGFloat kTimePickerTitleFont = 30.0;

typedef NS_ENUM(NSInteger,SLPTimePickerMode) {
    SLPTimePickerMode_24Hour = 0,
    SLPTimePickerMode_12Hour,
};

typedef NS_ENUM(NSInteger,SKPTimerPickerComponent) {
    SLPTimerPickerComponent_Hour = 0,
//    SLPTimerPickerComponent_Colon,
    SLPTimerPickerComponent_Minute,
    SLPTimerPickerComponent_AMPM,
};

@protocol SLPTimePickerDelegate;
@interface SLPTimePicker : UIView
@property (nonatomic,assign)SLPTimePickerMode mode;
@property (nonatomic,weak) id<SLPTimePickerDelegate>delegate;
@property (nonatomic,readonly) SLPTime24 *time;

- (void)setTime:(SLPTime24 *)time animated:(BOOL)animated;
@end


@protocol SLPTimePickerDelegate <NSObject>
@optional
- (void)slpTimePickerValueChanged:(SLPTimePicker *)pickerView;
- (CGFloat)slpTimePicker:(SLPTimePicker *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)slpTimePicker:(SLPTimePicker *)pickerView rowHeightForComponent:(NSInteger)component;

- (UIFont *)slpTimerPicker:(SLPTimePicker *)pickerView titleFontForRow:(NSInteger)row forComponent:(NSInteger)component;
- (UIColor *)slpTimerPicker:(SLPTimePicker *)pickerView titleColorForRow:(NSInteger)row forComponent:(NSInteger)component;


@end
