//
//  AlarmDataModel.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AlarmDataModel.h"

@implementation AlarmDataModel

- (instancetype)init{
    if (self = [super init]) {
        _smartFlag = YES;
        _snoozeFlag = NO;
        _hour = 8;
        _minute = 0;
        _aromaFlag = YES;
        _lightFlag = YES;
        _awakeRange = 1;
        _snoozeRange = 5;
    }
    
    return self;
}

@end
