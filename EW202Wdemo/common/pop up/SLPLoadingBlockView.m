//
//  SLPLoadingBlockView.m
//  Sleepace
//
//  Created by Martin on 2017/5/23.
//  Copyright © 2017年 com.medica. All rights reserved.
//

#import "SLPLoadingBlockView.h"

@interface SLPLoadingBlockView ()
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *contentVerticalCenter;
@property (nonatomic, weak) IBOutlet UILabel *label;
@end
@implementation SLPLoadingBlockView

- (void)awakeFromNib{
    [super awakeFromNib];
//    [self.maskView setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor blackColor]];
    [self.contentView setAlpha:1];
    [Utils setView:self.contentView cornerRadius:10.0 borderWidth:0 color:[UIColor clearColor]];
    [self.activityIndicatorView startAnimating];
    [self.label setFont:Theme.T1];
    self.label.textColor = [Theme C9];
}

- (void)showInViewController:(UIViewController *)viewController topEdge:(CGFloat)topEdge animated:(BOOL)animated{
    NSInteger topEdgeHalf = -topEdge*0.5;
    [self.contentVerticalCenter setConstant:topEdgeHalf];
    if (topEdge == 0){
        [self showInViewController:viewController animated:animated];
    }else{
        UIView *superView = [Utils keyWindow];
        UIView *subView = self;
        [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [superView addSubview:subView];
        NSDictionary *subViews = NSDictionaryOfVariableBindings(subView,superView);
        [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:subViews]];
        NSString *vFormat = [NSString stringWithFormat:@"V:|-%f-[subView]|",topEdge];
        [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:nil views:subViews]];
        [self.bgView setAlpha:1.0];
        if (animated){
            [self.bgView setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
            [UIView animateWithDuration:kAlertAnimationInterval animations:^{
                [self.bgView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            }];
        }else{
            [self.bgView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        }
    }
}

+ (SLPLoadingBlockView *)showInViewController:(UIViewController *)viewController
                                      topEdge:(CGFloat)topEdge animated:(BOOL)animated{
    SLPLoadingBlockView *loadingView = [[[NSBundle mainBundle] loadNibNamed:@"SLPLoadingBlockView" owner:self options:nil] firstObject];
    [loadingView showInViewController:viewController topEdge:topEdge animated:animated];
    return loadingView;
}

- (void)setText:(NSString *)text {
    [self.activityIndicatorView setHidden:text.length > 0];
    [self.label setText:text];
}
@end
