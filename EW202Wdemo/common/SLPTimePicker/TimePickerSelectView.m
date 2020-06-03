//
//  TimePickerSelectView.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/19.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "TimePickerSelectView.h"

#define kMaxTransformScale (1.0)
#define kMinTransformScale (0.002)
#define kMaxAlpha (0.6)
#define kMinAlpha (0.0)

#define kAnimationDuration (0.3)

@interface TimePickerSelectView ()<SLPTimePickerDelegate>
{
    FinishSelectTimeBlock _finishHandle;
    CancelSelectTimeBlock _cancelHandle;
}

@property (weak, nonatomic) IBOutlet SLPTimePicker *timePicker;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *btnBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@property (nonatomic, strong) SLPTime24 *time24;

@end

@implementation TimePickerSelectView

+ (TimePickerSelectView *)timePickerSelectView{
    TimePickerSelectView *selectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    return selectView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
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


- (void)showInView:(UIView *)view mode:(SLPTimePickerMode)mode time:(SLPTime24 *)time finishHandle:(FinishSelectTimeBlock)finishHandle cancelHandle:(CancelSelectTimeBlock)cancelHandle
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
    
    self.timePicker.delegate = self;
    [self.timePicker setMode:mode];
    [self.timePicker setTime:time animated:YES];
    
    _finishHandle = finishHandle;
    _cancelHandle = cancelHandle;
}

#pragma mark - SLPTimePickerDelegate

- (CGFloat)slpTimePicker:(SLPTimePicker *)pickerView widthForComponent:(NSInteger)component {
    return kTimePickerWidth;
}

- (CGFloat)slpTimePicker:(SLPTimePicker *)pickerView rowHeightForComponent:(NSInteger)component {
    return kTimePickerHeight;
}

- (UIFont *)slpTimerPicker:(SLPTimePicker *)pickerView titleFontForRow:(NSInteger)row forComponent:(NSInteger)component {
    UIFont *font = nil;
    switch (component) {
        case SLPTimerPickerComponent_AMPM:
            font = [UIFont systemFontOfSize:kAMPMFont];
            break;
        default:
            font = [UIFont systemFontOfSize:kTimePickerTitleFont];
            break;
    }
    return font;
}
- (UIColor *)slpTimerPicker:(SLPTimePicker *)pickerView titleColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [Theme C3];
}

- (void)slpTimePickerValueChanged:(SLPTimePicker *)pickerView {
    SLPTime24 *time24 = pickerView.time;
    self.time24 = time24;
}

- (IBAction)cancel:(id)sender {
    if (_cancelHandle) {
        _cancelHandle();
    }
    [self hideViewWithAnimated:YES];
}
- (IBAction)done:(id)sender {
    if (_finishHandle) {
        _finishHandle(self.time24);
    }
    [self hideViewWithAnimated:YES];
}

@end
