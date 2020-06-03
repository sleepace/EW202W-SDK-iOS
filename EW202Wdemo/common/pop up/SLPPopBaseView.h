//
//  SLPPopBaseView.h
//  Sleepace
//
//  Created by Martin on 8/29/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAlertAnimationInterval (0.3)
@interface SLPPopBaseView : UIView
@property (nonatomic,weak) IBOutlet UIView *maskView;
@property (nonatomic,weak) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *bgView;
- (void)showInViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)unshowAnimated:(BOOL)animated;
@end
