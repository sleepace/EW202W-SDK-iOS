//
//  BaseViewController.h
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLPLoadingBlockView.h"

@interface BaseViewController : UIViewController
@property (nonatomic,weak) IBOutlet UIView *navigationShell;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *navigationShellHeight;
@property (nonatomic,weak) IBOutlet UIView *navigationBar;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UIButton *backButton;
@property (nonatomic,weak) IBOutlet UIView *line;

- (void)back;

- (SLPLoadingBlockView *)showLoadingView;
- (void)unshowLoadingView;

- (BOOL)checkAndShowAlertWithConnectStatus;
@end
