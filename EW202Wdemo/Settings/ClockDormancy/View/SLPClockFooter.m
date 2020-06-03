//
//  SLPClockFooter.m
//  EW202Wdemo
//
//  Created by Michael on 2020/6/2.
//  Copyright © 2020 medica. All rights reserved.
//

#import "SLPClockFooter.h"

@implementation SLPClockFooter

+ (instancetype)footerViewWithTextStr:(NSString *)textStr {
    SLPClockFooter *footer = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    [SLPUtils setLableNormalAttributes:footer.textLabel text:textStr font:[Theme T4]];
    
    return footer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.font = [Theme T4];
    self.textLabel.textColor = [Theme C4];
//    [SLPUtils configSomeKindOfButtonLikeRegister:self.previewBtn];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
