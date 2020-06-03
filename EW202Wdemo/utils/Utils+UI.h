//
//  Utils+UI.h
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "Utils.h"

@interface Utils (UI)
+ (UIColor *)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;
+ (void)setButton:(UIButton *)button title:(NSString *)title;
+ (void)configNormalButton:(UIButton *)button;
+ (void)configNormalDetailLabel:(UILabel *)label;
+ (void)configSectionTitle:(UILabel *)label;
+ (void)configCellTitleLabel:(UILabel *)label;
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle atViewController:(UIViewController *)viewController;
+ (void)showDeviceOperationFailed:(NSInteger)status atViewController:(UIViewController *)viewController;
+ (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth color:(UIColor *)color;
+ (void)removeAllSubViewsFrom:(UIView *)view;
+ (UIWindow *)keyWindow;

+ (void)showMessage:(NSString *)message controller:(UIViewController *)controller;
@end
