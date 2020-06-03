//
//  TitleValueSwitchCellTableViewCell.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "TitleValueSwitchCellTableViewCell.h"

@implementation TitleValueSwitchCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchAction:(UISwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender);
    }
}

@end
