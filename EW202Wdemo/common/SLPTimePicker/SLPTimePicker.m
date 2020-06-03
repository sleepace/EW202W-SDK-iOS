//
//  SLPTimePicker.m
//  Profession
//
//  Created by Martin on 4/7/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPTimePicker.h"
#import "SLPTime12.h"

static const CGFloat kHourWidth = 60;
//static const CGFloat kColonWidth = 15;
static const CGFloat kMinuteWidth = 60;
static const CGFloat kAMPMWidth = 50;
static const CGFloat kTimePickerComponentHeight = 50;

enum{
    SLPTimeAM = 0, //上午
    SLPTimePM,//下午
    
    SLPTimeButtom,
};

static const NSInteger g_repeatBase = 1000;
static const NSInteger g_repeatBegin = 500;
static const NSInteger g_minuteCount = 60;

@interface SLPBaseTimePickerView : UIPickerView

@end

@implementation SLPBaseTimePickerView

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    [self setupIndicatorView:subview];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    for (UIView *subview in self.subviews) {
        [self setupIndicatorView:subview];
    }
}

- (void)setupIndicatorView:(UIView *)indicatorView {
    if (CGRectGetHeight(indicatorView.bounds) <= 1.0) {
        indicatorView.backgroundColor = [Theme normalLineColor];
        CGRect frame = indicatorView.frame;
        frame.size.height = 0.5;
        indicatorView.frame = frame;
    }
}

@end

@interface SLPTimePicker()<UIPickerViewDelegate,UIPickerViewDataSource>{
    SLPBaseTimePickerView *_pickerView;
}

@end

@implementation SLPTimePicker

- (id)init{
    if (self = [super init]){
        [self createPickerView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self createPickerView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self createPickerView];
}

- (void)createPickerView{
    _pickerView = [[SLPBaseTimePickerView alloc] init];
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    [_pickerView setDataSource:self];
    [_pickerView setDelegate:self];
    [_pickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_pickerView];
    
    NSDictionary *subViews = NSDictionaryOfVariableBindings(_pickerView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickerView]|" options:0 metrics:nil views:subViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_pickerView]|" options:0 metrics:nil views:subViews]];
}

- (SLPTime24 *)time{
    NSInteger hour = [_pickerView selectedRowInComponent:SLPTimerPickerComponent_Hour];
    hour = hour%[self _hourCount];
    NSInteger minute = [_pickerView selectedRowInComponent:SLPTimerPickerComponent_Minute];
    minute = minute%g_minuteCount;
    if (self.mode == SLPTimePickerMode_12Hour){
        NSInteger ampmRow = [_pickerView selectedRowInComponent:SLPTimerPickerComponent_AMPM];
        BOOL isAm = (ampmRow == SLPTimeAM);
        SLPTime12 *time12 = [[SLPTime12 alloc] init];
        [time12 setHour:hour + 1];
        [time12 setMinute:minute];
        [time12 setIsAM:isAm];
        return [time12 convertToTime24];
    }else{
        SLPTime24 *time24 = [[SLPTime24 alloc] init];
        [time24 setHour:hour];
        [time24 setMinute:minute];
        return time24;
    }
}

- (void)setTime:(SLPTime24 *)time animated:(BOOL)animated{
    NSInteger minute = time.minute;
    minute += g_minuteCount *g_repeatBegin;
    
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:minute inComponent:SLPTimerPickerComponent_Minute animated:animated];
    if (self.mode == SLPTimePickerMode_24Hour){
        NSInteger hour = time.hour;
        hour += [self _hourCount]*g_repeatBegin;
        [_pickerView selectRow:hour inComponent:SLPTimerPickerComponent_Hour animated:animated];
    }else{
        SLPTime12 *timer12 = [time convertToTime12];
        NSInteger hour = timer12.hour;
        hour += [self _hourCount]*g_repeatBegin;
        [_pickerView selectRow:hour-1 inComponent:SLPTimerPickerComponent_Hour animated:animated];
        NSInteger ampm = timer12.isAM?SLPTimeAM:SLPTimePM;
        [_pickerView selectRow:ampm inComponent:SLPTimerPickerComponent_AMPM animated:animated];
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    NSInteger componentCount = 2;
    if (self.mode == SLPTimePickerMode_12Hour){
        componentCount = 3;
    }
    return componentCount;
}

- (NSInteger)_hourCount{
    NSInteger count = 24;
    if (self.mode == SLPTimePickerMode_12Hour){
        count = 12;
    }
    return count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger row = 0;
    switch (component) {
        case SLPTimerPickerComponent_Hour:
            row = [self _hourCount] * g_repeatBase;
            break;
//        case SLPTimerPickerComponent_Colon:
//            row = 1;
//            break;
        case SLPTimerPickerComponent_Minute:
            row = g_minuteCount * g_repeatBase;
            break;
        case SLPTimerPickerComponent_AMPM:
            row = SLPTimeButtom;
            break;
        default:
            break;
    }
    return row;
}

#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat width = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpTimePicker:widthForComponent:)]){
        width = [self.delegate slpTimePicker:self widthForComponent:component];
    }else{
        switch (component) {
            case SLPTimerPickerComponent_Hour:
                width = kHourWidth;
                break;
//            case SLPTimerPickerComponent_Colon:
//                width = kColonWidth;
//                break;
            case SLPTimerPickerComponent_Minute:
                width = kMinuteWidth;
                break;
            case SLPTimerPickerComponent_AMPM:
                width = kAMPMWidth;
                break;
            default:
                break;
        }
    }
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    CGFloat height = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpTimePicker:rowHeightForComponent:)]){
        height = [self.delegate slpTimePicker:self rowHeightForComponent:component];
    }else{
        height = kTimePickerComponentHeight;
    }
    return height;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    NSString *title = nil;
    switch (component) {
        case SLPTimerPickerComponent_Hour:
            row = row%[self _hourCount];
            if (self.mode == SLPTimePickerMode_12Hour){
                title = [NSString stringWithFormat:@"%02d",(int)row+1];
            }else{
                title = [NSString stringWithFormat:@"%02d",(int)row];
            }
            
            break;
//        case SLPTimerPickerComponent_Colon:
//            title = @":";
//            break;
        case SLPTimerPickerComponent_Minute:
            row = row%g_minuteCount;
            title = [NSString stringWithFormat:@"%02d",(int)row];
            break;
        case SLPTimerPickerComponent_AMPM:
            title = @"AM";
            if (row == SLPTimePM){
                title = @"PM";
            }
            break;
        default:
            break;
    }
    
    UIFont *font = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpTimerPicker:titleFontForRow:forComponent:)]){
        font = [self.delegate slpTimerPicker:self titleFontForRow:row forComponent:component];
    }else{
        font = [UIFont systemFontOfSize:kTimePickerTitleFont];
    }
    UIColor *color = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpTimerPicker:titleColorForRow:forComponent:)]){
        color = [self.delegate slpTimerPicker:self titleColorForRow:row forComponent:component];
    }else{
        color = [Theme C3];
    }
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setFont:font];
    [label setTextColor:color];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpTimePickerValueChanged:)]){
        [self.delegate slpTimePickerValueChanged:self];
    }
}
@end
