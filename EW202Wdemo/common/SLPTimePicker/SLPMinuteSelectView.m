//
//  SLPMinuteSelectView.m
//  Sleepace
//
//  Created by Shawley on 7/27/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPMinuteSelectView.h"

#define kMaxTransformScale (1.0)
#define kMinTransformScale (0.002)
#define kMaxAlpha (0.6)
#define kMinAlpha (0.0)

#define kAnimationDuration (0.3)

@interface SLPMinuteSelectView () <SLPMinutePickerDelegate>
{
    FinishBtnTappedBlock _finishHandle;
    CancelBtnTappedBlock _cancelHandle;
    
}
@property (nonatomic,strong) NSArray *iValues;//选项 正整数

@property (weak, nonatomic) IBOutlet SLPMinutePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *btnBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@end

@implementation SLPMinuteSelectView

+ (SLPMinuteSelectView *)minuteSelectViewWithValues:(NSArray<NSNumber *> *)iValues{
    SLPMinuteSelectView *selectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    [selectView setIValues:iValues];
    return selectView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
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

- (IBAction)finishBtnTapped:(id)sender {
    if (_finishHandle) {
        _finishHandle(self.timePicker.time);
    }
    [self hideViewWithAnimated:YES];
}

- (IBAction)cancelBtnTapped:(id)sender {
    if (_cancelHandle) {
        _cancelHandle();
    }
    [self hideViewWithAnimated:YES];
}

- (void)showInView:(UIView *)view mode:(SLPMinutePickerMode)mode time:(NSInteger)time finishHandle:(FinishBtnTappedBlock)finishHandle cancelHandle:(CancelBtnTappedBlock)cancelHandle
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
    [self.timePicker setIValues:self.iValues];
    [self.timePicker setSelectedValue:time];
    
    _finishHandle = finishHandle;
    _cancelHandle = cancelHandle;
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

-(UIColor *)slpMinutePicker:(SLPMinutePicker *)pickerView titleColorForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [Theme C3];
}
@end
