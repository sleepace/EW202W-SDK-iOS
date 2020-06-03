//
//  Theme.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "Theme.h"

@implementation Theme
+ (UIColor *)C1{
    return [self colorWithRGB:0x76bcfe alpha:1.0];
}

+ (UIColor *)C1Disable{
    return [self colorWithRGB:0xd6dadf alpha:1.0];
}

+ (UIColor *)C2{
    return [self colorWithRGB:0x2a97fe alpha:1.0];
}

+ (UIColor *)C3{
    return [self colorWithRGB:0x263444 alpha:1.0];
}

+ (UIColor *)C4{
    return [self colorWithRGB:0x8492a6 alpha:1.0];
}

+ (UIColor *)C5{
    return [self colorWithRGB:0xe0e6ed alpha:0.5];
}

+ (UIColor *)C6{
    return [self colorWithRGB:0x14cf67 alpha:1.0];
}

+ (UIColor *)C7{
    return [self colorWithRGB:0xff4949 alpha:1.0];
}

+ (UIColor *)C8{
    return [self colorWithRGB:0x222642 alpha:1.0];
}

+ (UIColor *)C9{
    return [self colorWithRGB:0xffffff alpha:1.0];
}

+ (UIColor *)C10{
    return [self colorWithRGB:0x353b66 alpha:1.0];
}

+ (UIColor *)C11{
    return [self colorWithRGB:0x1d2036 alpha:1.0];
}

+ (UIColor *)C12{
    return [self colorWithRGB:0x4d5582 alpha:1.0];
}

+ (UIColor *)C13{
    return [self colorWithRGB:0xd6dadf alpha:1.0];
}

+ (UIColor *)normalLineColor {
    return [self C5];
}

+ (UIColor *)colorOf:(UIColor *)color alpha:(CGFloat)alpha{
    CGFloat r,g,b;
    [color getRed:&r green:&g blue:&b alpha:nil];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

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


+ (UIFont *)T1{
    return [self fontWithSize:17];
}

+ (UIFont *)T2{
    return [self fontWithSize:16];
}

+ (UIFont *)T3{
    return [self fontWithSize:15];
}

+ (UIFont *)T4{
    return [self fontWithSize:14];
}

+ (UIFont *)fontWithSize:(CGFloat)size{
    return [UIFont systemFontOfSize:size];
}
@end
