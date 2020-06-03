//
//  CustomStyleButton.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/15.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "CustomStyleButton.h"

@implementation CustomStyleButton


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTitleColor:[Theme C3] forState:UIControlStateNormal];
    
}

-(void)setSelected:(BOOL)selected
{
    if (selected) {
        self.backgroundColor = [Theme C2];
        [self setTitleColor:self.selectedColor forState:UIControlStateNormal];
    }else{
        self.backgroundColor = [Theme C9];
        [self setTitleColor:self.normalColor forState:UIControlStateNormal];
    }
}

@end
