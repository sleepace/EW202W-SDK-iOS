//
//  DatePickerPopUpView.h
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "PopUpView.h"

@interface DatePickerPopUpView : PopUpView
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *confirmBtn;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

- (void)showInViewController:(UIViewController *)viewController animated:(BOOL)animated confirmCallback:(void(^)(NSDate *date))confirmCallback;
@end
