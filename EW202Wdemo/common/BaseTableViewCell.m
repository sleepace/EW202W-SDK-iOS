//
//  BaseTableViewCell.m
//  Binatone-demo
//
//  Created by Martin on 27/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()
@end

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.lineDown setBackgroundColor:[Theme normalLineColor]];
}


@end
