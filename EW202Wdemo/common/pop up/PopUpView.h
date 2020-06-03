//
//  PopUpView.h
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpView : UIView
@property (nonatomic, weak) IBOutlet UIView *maskView;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentBottomEdge;

- (void)showInViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)unshowAnimated:(BOOL)animated;
- (IBAction)tapEmpty:(id)sender;
@end
