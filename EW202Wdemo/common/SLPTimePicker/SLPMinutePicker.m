//
//  SLPMinutePicker.m
//  Sleepace
//
//  Created by Shawley on 7/27/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPMinutePicker.h"

static const CGFloat kPickerComponentWidth = 120.0;
static const CGFloat kPickerComponentHeight = 50.0;
static const CGFloat kMinutePickerTitleFont = 26.0;

@interface SLPMinutePicker() <UIPickerViewDelegate,UIPickerViewDataSource> {
    UIPickerView *_pickerView;
}

@end

@implementation SLPMinutePicker

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
    _pickerView = [[UIPickerView alloc] init];
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    [_pickerView setDataSource:self];
    [_pickerView setDelegate:self];
    [_pickerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_pickerView];
    
    NSDictionary *subViews = NSDictionaryOfVariableBindings(_pickerView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickerView]|" options:0 metrics:nil views:subViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_pickerView]|" options:0 metrics:nil views:subViews]];
}

- (void)setSelectedValue:(NSInteger)value{
    NSInteger row = NSNotFound;
    for (NSNumber *oValue in self.iValues){
        if ([oValue integerValue] == value){
            row = [self.iValues indexOfObject:oValue];
            break;
        }
    }
    
    if (row == NSNotFound){
        row = 0;
    }
    [self performSelectorOnMainThread:@selector(setSelectedRowAt:) withObject:[NSNumber numberWithInteger:row] waitUntilDone:NO];
}

- (void)setSelectedRowAt:(NSNumber *)rowNumber{
    [_pickerView selectRow:[rowNumber integerValue] inComponent:0 animated:NO];
}

- (NSInteger)time {
    NSInteger row = [_pickerView selectedRowInComponent:0];
    NSInteger value = [[self.iValues objectAtIndex:row] integerValue];
    return value;
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger row = 0;
    row = [self.iValues count];
    return row;
}

#pragma mark SLPMinutePickerDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat width = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpMinutePicker:widthForComponent:)]){
        width = [self.delegate slpMinutePicker:self widthForComponent:component];
    }else{
        width = kPickerComponentWidth;
    }
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    CGFloat height = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpMinutePicker:rowHeightForComponent:)]){
        height = [self.delegate slpMinutePicker:self rowHeightForComponent:component];
    }else{
        height = kPickerComponentHeight;
    }
    return height;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [Theme normalLineColor];
        }
    }
    NSString *title = nil;
    NSInteger value = [[self.iValues objectAtIndex:row] integerValue];
    switch (self.mode) {
        case SLPMinutePickerMode_Hour:
            title = [NSString stringWithFormat:@"%d%@",(int)value, LocalizedString(@"hour")];
            break;
        case SLPMinutePickerMode_Minute:
            title = [NSString stringWithFormat:@"%d%@",(int)value, LocalizedString(@"min")];
            break;
        case SLPMinutePickerMode_Second:
            title = [NSString stringWithFormat:@"%d%@",(int)value, LocalizedString(@"")];
            break;
        case SLPMinutePickerMode_TimeFormat:
        {
            if (value == 12) {
                title = LocalizedString(@"time_format_12");
            } else {
                title = LocalizedString(@"time_format_24");
            }
        }
        default:
            break;
    }
    
    UIFont *font = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpMinutePicker:titleFontForRow:forComponent:)]){
        font = [self.delegate slpMinutePicker:self titleFontForRow:row forComponent:component];
    }else{
        font = [UIFont systemFontOfSize:kMinutePickerTitleFont];
    }
    UIColor *color = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpMinutePicker:titleColorForRow:forComponent:)]){
        color = [self.delegate slpMinutePicker:self titleColorForRow:row forComponent:component];
    }else{
        color = [UIColor blackColor];
    }
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setFont:font];
    [label setTextColor:color];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.delegate && [self.delegate respondsToSelector:@selector(slpMinutePickerValueChanged:)]){
        [self.delegate slpMinutePickerValueChanged:self];
    }
}

@end
