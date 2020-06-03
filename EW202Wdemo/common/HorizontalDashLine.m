//
//  HorizontalDashLine.m
//  Test
//
//  Created by Martin on 27/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "HorizontalDashLine.h"

@interface HorizontalDashLine ()
{
    CAShapeLayer  *_shapeLayer;
    UIColor *_backgroundColor;
}
@end

@implementation HorizontalDashLine

+ (Class)layerClass{
    return [CAShapeLayer class];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    UIBezierPath *path      = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(bounds.size.width, 0)];
    _shapeLayer             = (CAShapeLayer *)self.layer;
    _shapeLayer.fillColor   = [UIColor clearColor].CGColor;
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd   = 1;
    _shapeLayer.lineWidth   = bounds.size.height;
    _shapeLayer.path        = path.CGPath;
    _shapeLayer.strokeColor = _backgroundColor.CGColor;
    [_shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:1],nil]];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _shapeLayer.strokeColor = backgroundColor.CGColor;
    _backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
    return _backgroundColor;
}
@end
