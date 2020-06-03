//
//  SLPLabelFooter.h
//  Sleepace
//
//  Created by Shawley on 7/22/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kFooterHeight = 80;

@interface SLPLabelFooter : UIView

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *line;

+ (instancetype)footerViewWithTextStr:(NSString *)textStr;

+ (CGFloat)footerHeight:(NSString *)text;

- (void)setLabelTitleWithText:(NSString *)text;

@end
