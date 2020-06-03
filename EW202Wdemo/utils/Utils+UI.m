//
//  Utils+UI.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "Utils+UI.h"
#import "AppDelegate.h"

@implementation Utils (UI)

+ (UIColor *)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha{
    NSInteger red = (rgb >> 16 ) & 0xff;
    NSInteger green = (rgb >> 8 ) & 0xff;
    NSInteger blue = rgb & 0xff;
    return [self colorWithIRed:red iGreen:green iBlue:blue alpha:alpha];
}

+ (UIColor*)colorWithIRed:(NSInteger)red iGreen:(CGFloat)green iBlue:(CGFloat)blue alpha:(CGFloat)alpha{
    CGFloat iRed = red;
    CGFloat iGreen = green;
    CGFloat iBlue = blue;
    return [UIColor colorWithRed:iRed/255.0 green:iGreen/255.0 blue:iBlue/255.0 alpha:alpha];
}

+ (UIImage *)imageFromColor:(UIColor *)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat r,g,b,alpha;
    [color getRed:&r green:&g blue:&b alpha:&alpha];
    
    if (alpha == 1.0){
        return theImage;
    }
    
    UIGraphicsBeginImageContextWithOptions(theImage.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, theImage.size.width, theImage.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, theImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)setButton:(UIButton *)button title:(NSString *)title {
    [button.titleLabel setText:title];
    [button setTitle:title forState:UIControlStateNormal];
}

+ (void)configNormalButton:(UIButton *)button {
    [button setBackgroundImage:[self imageFromColor:Theme.C2] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageFromColor:Theme.C2] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self imageFromColor:Theme.C2] forState:UIControlStateSelected];
    [button setBackgroundImage:[self imageFromColor:Theme.C1Disable] forState:UIControlStateDisabled];
    [button.titleLabel setNumberOfLines:2];
    [button.titleLabel setFont:Theme.T3];
    [button.titleLabel setTextColor:Theme.C9];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:2.0];
}

+ (void)configNormalDetailLabel:(UILabel *)label{
    [label setTextColor:Theme.C3];
    [label setFont:Theme.T3];
    [label setNumberOfLines:2];
    [label.layer setMasksToBounds:YES];
    [label.layer setCornerRadius:2.0];
    [label.layer setBorderWidth:1.0];
    [label.layer setBorderColor:Theme.normalLineColor.CGColor];
}

+ (void)configSectionTitle:(UILabel *)label {
    [label setNumberOfLines:2];
    [label setTextColor:Theme.C4];
    [label setFont:Theme.T3];
}

+ (void)configCellTitleLabel:(UILabel *)label {
    [label setNumberOfLines:2];
    [label setTextColor:Theme.C3];
    [label setFont:Theme.T3];
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle atViewController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

+ (void)showDeviceOperationFailed:(NSInteger)status atViewController:(UIViewController *)viewController{
    if (status == -4) {
        [self showAlertTitle:nil message:LocalizedString(@"phone_bluetooth_not_open")
                confirmTitle:LocalizedString(@"confirm") atViewController:viewController];
    }else {
        [self showAlertTitle:LocalizedString(@"device_connect_fail") message:LocalizedString(@"device_w_ble_connect_failed_tip")
                confirmTitle:LocalizedString(@"confirm") atViewController:viewController];
    }
}

+ (void)setView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth color:(UIColor *)color{
    //设置layer
    CALayer *layer=[view layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:radius];
    //设置边框线的宽
    //
    [layer setBorderWidth:borderWidth];
    if (color){
        //设置边框线的颜色
        [layer setBorderColor:[color CGColor]];
    }
}

+ (void)removeAllSubViewsFrom:(UIView *)view {
    NSArray *subViews = view.subviews;
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
}

+ (UIWindow *)keyWindow{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *mainWindow = appDelegate.window;
    return mainWindow;
}

+ (void)showMessage:(NSString *)message controller:(UIViewController *)controller
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller presentViewController:alert animated:YES completion:nil];
    [[[alert.view.subviews firstObject].subviews firstObject].subviews firstObject].backgroundColor = [Theme colorOf:[UIColor blackColor] alpha:0.8];
    //控制提示框显示的时间为2秒
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:message];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, message.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, message.length)];
    [alert setValue:attrStr forKey:@"attributedMessage"];
    
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2.0];
}

+ (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}
@end
