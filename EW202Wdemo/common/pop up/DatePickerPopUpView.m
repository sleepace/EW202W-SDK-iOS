//
//  DatePickerPopUpView.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DatePickerPopUpView.h"

@interface DatePickerPopUpView ()
@property (nonatomic, copy) void(^confirmCallback)(NSDate *date);
@property (nonatomic, weak) IBOutlet UIView *line;
@end

@implementation DatePickerPopUpView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUI];
}

- (void)setUI {
    [self.line setBackgroundColor:Theme.normalLineColor];
    [self.titleLabel setFont:Theme.T1];
    [self.titleLabel setTextColor:Theme.C10];
    
    [Utils setButton:self.cancelBtn title:LocalizedString(@"cancel")];
    [Utils setButton:self.confirmBtn title:LocalizedString(@"confirm")];
}

- (void)unshowAnimated:(BOOL)animated {
    [super unshowAnimated:animated];
    self.confirmCallback = nil;
}

- (IBAction)cancelClicked:(id)sender {
    [self unshowAnimated:YES];
}

- (IBAction)confirmClicked:(id)sender {
    if (self.confirmCallback) {
        self.confirmCallback(self.datePicker.date);
    }
    [self unshowAnimated:YES];
}

- (void)showInViewController:(UIViewController *)viewController animated:(BOOL)animated confirmCallback:(void(^)(NSDate *date))confirmCallback {
    self.confirmCallback = confirmCallback;
    [self showInViewController:viewController animated:animated];
}
@end
