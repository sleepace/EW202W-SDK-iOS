//
//  TitleSubTitleArrowCell.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "TitleSubTitleArrowCell.h"

@implementation TitleSubTitleArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.arrowIcon.image = [UIImage imageNamed:@"common_list_icon_leftarrow"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
