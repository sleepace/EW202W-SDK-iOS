//
//  SLPPopBaseView.m
//  Sleepace
//
//  Created by Martin on 8/29/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPPopBaseView.h"

#define kMaskMaxAlpha (0.6)
@implementation SLPPopBaseView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.maskView setAlpha:0.3];
    [self.maskView setBackgroundColor:[UIColor blackColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)showInViewController:(UIViewController *)viewController animated:(BOOL)animated{
     UIView *view = [Utils keyWindow];
    [Utils addSubView:self suitableTo:view];
    [self.bgView setAlpha:1.0];
    
    __weak typeof(self) weakSelf = self;
    if (animated){
        [self.bgView setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
        [self.maskView setAlpha:0.0];
        [UIView animateWithDuration:kAlertAnimationInterval animations:^{
            [weakSelf.maskView setAlpha:kMaskMaxAlpha];
            [weakSelf.bgView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        }];
    }else{
        [self.maskView setAlpha:kMaskMaxAlpha];
        [self.bgView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }
}

- (void)unshowAnimated:(BOOL)animated{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAlertAnimationInterval animations:^{
        [weakSelf.bgView setAlpha:0.0];
        [weakSelf.bgView setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
        [weakSelf.maskView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
@end
