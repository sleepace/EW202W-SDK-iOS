//
//  SelectItemCell.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "SelectItemCell.h"

@implementation SelectItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectIcon.image = [UIImage imageNamed:@"list_icon_select"];
    self.selectIcon.hidden = YES;
}



@end
