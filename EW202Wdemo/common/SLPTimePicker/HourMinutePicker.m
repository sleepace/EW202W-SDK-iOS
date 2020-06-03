//
//  HourMinutePicker.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/19.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "HourMinutePicker.h"

#define kMaxTransformScale (1.0)
#define kMinTransformScale (0.002)
#define kMaxAlpha (0.6)
#define kMinAlpha (0.0)

#define kAnimationDuration (0.3)

static const CGFloat kHourMinuteWidth = 60;
static const CGFloat kUnitWidth = 60;

static const CGFloat kHourMinutePickerComponentHeight = 60;
static const CGFloat kHourMinutePickerTitleFont = 28.0;

@interface HourMinutePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    FinishSelectHourMinuteBlock _finishHandle;
    CancelSelectHourMinuteBlock _cancelHandle;
}

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *btnBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

@property (nonatomic, assign) NSInteger hour;

@property (nonatomic, assign) NSInteger minute;
@end

@implementation HourMinutePicker

+ (HourMinutePicker *)hourMinutePickerSelectView{
    HourMinutePicker *selectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return selectView;
}

- (void)showInView:(UIView *)view hour:(NSInteger)hour minute:(NSInteger)minute finishHandle:(FinishSelectHourMinuteBlock)finishHandle cancelHandle:(CancelSelectHourMinuteBlock)cancelHandle
{
    [view addSubview:self];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView *selfView = self;
    NSDictionary *subViews = NSDictionaryOfVariableBindings(selfView);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[selfView]|" options:0 metrics:nil views:subViews]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[selfView]|" options:0 metrics:nil views:subViews]];
    
    [self.backgroundView setTransform:CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.backgroundView.frame))];
    [self.maskView setAlpha:kMinAlpha];
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [weakSelf.maskView setAlpha:kMaxAlpha];
        [weakSelf.backgroundView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    } completion:^(BOOL finished) {
    }];
    
    self.hour = hour;
    self.minute = minute;
    
    [self performSelectorOnMainThread:@selector(setFirstComponentSelectedRow:) withObject:@(hour) waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(setThirdComponentSelectedRow:) withObject:@(minute) waitUntilDone:NO];
    
    _finishHandle = finishHandle;
    _cancelHandle = cancelHandle;
}

- (void)setThirdComponentSelectedRow:(NSNumber *)row
{
    [_timePicker selectRow:[row integerValue] inComponent:2 animated:NO];
}

- (void)setFirstComponentSelectedRow:(NSNumber *)row{
    [_timePicker selectRow:[row integerValue] inComponent:0 animated:NO];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    
    [self.maskView setBackgroundColor:[Theme colorOf:[UIColor blackColor] alpha:0.8]];
    self.btnBackgroundView.backgroundColor = [Theme C5];
    [self.backgroundView setBackgroundColor:[Theme C9]];
    [self.finishBtn setTitle:LocalizedString(@"done") forState:UIControlStateNormal];
    [self.cancelBtn setTitle:LocalizedString(@"cancel") forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[Theme C2] forState:UIControlStateNormal];
    [self.finishBtn.titleLabel setFont:[Theme T2]];
    [self.cancelBtn setTitleColor:[Theme C4] forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[Theme T2]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedBg:)];
    [self.maskView addGestureRecognizer:tap];
}

- (void)tapedBg:(UIGestureRecognizer *)ges
{
    if (_cancelHandle) {
        _cancelHandle();
    }
    [self hideViewWithAnimated:YES];
}

- (void)hideViewWithAnimated:(BOOL)animated
{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [weakSelf.maskView  setAlpha:kMinAlpha];
        [weakSelf.backgroundView setTransform:CGAffineTransformMakeTranslation(0, CGRectGetHeight(weakSelf.backgroundView.frame))];
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    NSInteger componentCount = 4;
    return componentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger row = 0;
    switch (component) {
        case HourMinutePickerComponent_Hour:
            row = 24;
            break;
        case HourMinutePickerComponent_HourUnit:
            row = 1;
            break;
        case HourMinutePickerComponent_Minute:
            row = 60;
            break;
        case HourMinutePickerComponent_MinuteUnit:
            row = 1;
            break;
        default:
            break;
    }
    return row;
}

#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat width = 0;
    switch (component) {
        case HourMinutePickerComponent_Hour:
        case HourMinutePickerComponent_Minute:
            width = kHourMinuteWidth;
            break;
        case HourMinutePickerComponent_HourUnit:
        case HourMinutePickerComponent_MinuteUnit:
            width = kUnitWidth;
            break;
        default:
            break;
    }
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    CGFloat height = kHourMinutePickerComponentHeight;
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
    switch (component) {
        case HourMinutePickerComponent_Hour:
            title = [NSString stringWithFormat:@"%02d",(int)row];
            break;
        case HourMinutePickerComponent_HourUnit:
            title = LocalizedString(@"hour");
            break;
        case HourMinutePickerComponent_Minute:
            title = [NSString stringWithFormat:@"%02d",(int)row];
            break;
        case HourMinutePickerComponent_MinuteUnit:
            title = LocalizedString(@"min");
            break;
        default:
            break;
    }
    
    UIFont *font = [UIFont systemFontOfSize:kHourMinutePickerTitleFont];
    
    UIColor *color = [Theme C3];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setFont:font];
    [label setTextColor:color];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.hour = row;
    }else if (component == 2){
        self.minute = row;
    }
}

- (IBAction)cancel:(id)sender {
    if (_cancelHandle) {
        _cancelHandle();
    }
    [self hideViewWithAnimated:YES];
}
- (IBAction)done:(id)sender {
    
    if (_finishHandle) {
        _finishHandle(self.hour, self.minute);
    }
    [self hideViewWithAnimated:YES];
}
@end
