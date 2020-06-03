//
//  SLPWeekDay.m
//  Sleepace
//
//  Created by Shawley on 01/12/2016.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPWeekDay.h"

@implementation SLPWeekDay

+ (NSString *)getNameWithIndex:(WeekDayMode)index {
    NSString *weekDayName = @"";
    switch (index) {
        case WeekDayModeMonday:
            weekDayName = LocalizedString(@"mon");
            break;
        case WeekDayModeTuesday:
            weekDayName = LocalizedString(@"tue");
            break;
        case WeekDayModeWednesday:
            weekDayName = LocalizedString(@"wed");
            break;
        case WeekDayModeTursday:
            weekDayName = LocalizedString(@"thur");
            break;
        case WeekDayModeFriday:
            weekDayName = LocalizedString(@"fri");
            break;
        case WeekDayModeSatarday:
            weekDayName = LocalizedString(@"sat");
            break;
        case WeekDayModeSunday:
            weekDayName = LocalizedString(@"sun");
            break;
        default:
            break;
    }
    return weekDayName;
}

+ (NSString *)getAlarmRepeatDayStringWithWeekDay:(int)weekDay {
    NSString *repeatDayStr = @"";
    UInt8 weekDayNumber = weekDay;
    
    for (int i = 0; i < 7; i++) {
        UInt8 repeatDay = 1 << i;
        BOOL isRepeat = repeatDay & weekDayNumber;
        if (isRepeat) {
            NSString *dayStr = [SLPWeekDay getNameWithIndex:i];
            dayStr = [dayStr stringByAppendingString:@"、"];
            repeatDayStr = [repeatDayStr stringByAppendingString:dayStr];
        }
    }
    if (repeatDayStr.length) {
        repeatDayStr = [repeatDayStr substringToIndex:repeatDayStr.length - 1];
    } else {
        repeatDayStr = LocalizedString(@"once");
    }
    return repeatDayStr;
}

@end
