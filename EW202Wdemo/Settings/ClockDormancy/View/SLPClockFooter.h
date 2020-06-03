//
//  SLPClockFooter.h
//  EW202Wdemo
//
//  Created by Michael on 2020/6/2.
//  Copyright © 2020 medica. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPClockFooter : UIView

@property (nonatomic , assign) IBOutlet UILabel *textLabel;

+ (instancetype)footerViewWithTextStr:(NSString *)textStr;

@end

NS_ASSUME_NONNULL_END
