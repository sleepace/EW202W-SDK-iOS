//
//  PopUpView.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "PopUpView.h"

#define kAnimationDuration (0.3)
#define kMaskMaxAlpha (0.6)

@implementation PopUpView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.maskView setBackgroundColor:[UIColor blackColor]];
    [self.maskView setAlpha:0.0];
    [self.bgView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEmpty:)];
    [self.bgView addGestureRecognizer:tap];
}

- (void)showInViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIView *view = [Utils keyWindow];
    [Utils addSubView:self suitableTo:view];
    __weak typeof(self) weakSelf = self;
    if (animated){
        [self.maskView setAlpha:0.0];
        [self.contentBottomEdge setConstant:-self.contentHeight.constant];
        [self.bgView layoutIfNeeded];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [weakSelf.maskView setAlpha:kMaskMaxAlpha];
            [weakSelf.contentBottomEdge setConstant:0];
            [weakSelf.bgView layoutIfNeeded];
        }];
    }else{
        [self.maskView setAlpha:kMaskMaxAlpha];
        [self.contentBottomEdge setConstant:0];
    }
}

- (void)unshowAnimated:(BOOL)animated{
    __weak typeof(self) weakSelf = self;
    if (animated){
        [self.bgView layoutIfNeeded];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [weakSelf.maskView setAlpha:0.0];
            [weakSelf.contentBottomEdge setConstant:-weakSelf.contentHeight.constant];
            [weakSelf.bgView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

- (IBAction)tapEmpty:(id)sender {
    [self unshowAnimated:YES];
}
@end
