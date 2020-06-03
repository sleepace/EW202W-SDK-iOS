//
//  SLPAlarmFooter.h
//  Sleepace
//
//  Created by Shawley on 8/1/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLPAlarmFooterDelegate <NSObject>

@optional
- (void)previewBtnTapped:(BOOL)isSelected completion:(void (^)(BOOL result))completion;

- (void)deleteBtnTapped;

@end

@interface SLPAlarmFooter : UIView

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIButton *previewBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, assign) BOOL isPreviewEnabled;

@property (weak, nonatomic) id<SLPAlarmFooterDelegate> delegate;

+ (instancetype)footerViewWithTextStr:(NSString *)textStr;

- (CGFloat)footerLabelHeight;
- (CGFloat)height;
@end
