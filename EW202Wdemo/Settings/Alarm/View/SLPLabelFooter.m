//
//  SLPLabelFooter.m
//  Sleepace
//
//  Created by Shawley on 7/22/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPLabelFooter.h"

static const NSInteger kOffsetEdge = 15;

@implementation SLPLabelFooter

+ (instancetype)footerViewWithTextStr:(NSString *)textStr {
    SLPLabelFooter *footer = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    [SLPUtils setLableNormalAttributes:footer.label text:textStr font:self.defaultFont];
    return footer;
}

+ (CGFloat)footerHeight:(NSString *)text {
    return 0.1;
}

+ (UIFont *)defaultFont {
    return [Theme T4];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.textColor = [Theme C4];
    self.label.font = [Theme T4];
    
    self.line.backgroundColor = [Theme normalLineColor];
    self.line.hidden = YES;
}

- (void)setLabelTitleWithText:(NSString *)text {
    self.label.text = text;
}

@end
