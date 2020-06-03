//
//  TabBarItemCell.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "TabBarItemCell.h"

@implementation TabBarItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUI];
}

- (void)setUI {
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:Theme.T1];
    [self.titleLabel setNumberOfLines:2];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected {
    [self.titleLabel setTextColor:selected ? Theme.C2 : Theme.C4];
}

@end
