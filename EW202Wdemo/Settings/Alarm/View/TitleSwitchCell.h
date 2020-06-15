//
//  TitleSwitchCell.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void (^SwitcherBlock)(UISwitch *_Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface TitleSwitchCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@property (nonatomic, copy) SwitcherBlock switchBlock;

@end

NS_ASSUME_NONNULL_END
