//
//  SLPWeekDay.h
//  Sleepace
//
//  Created by Shawley on 01/12/2016.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WeekDayMode) {
    WeekDayModeMonday = 0,
    WeekDayModeTuesday,
    WeekDayModeWednesday,
    WeekDayModeTursday,
    WeekDayModeFriday,
    WeekDayModeSatarday,
    WeekDayModeSunday,
};

typedef NS_ENUM(NSInteger, RepetitionInterval) {
    RepetitionIntervalWorkDay = 0x1f,
    RepetitionIntervalWeekEnd = 0x60,
    RepetitionIntervalEveryDay = 0x7f,
};

@interface SLPWeekDay : NSObject

+ (NSString *)getAlarmRepeatDayStringWithWeekDay:(int)weekDay;

//获得星期名称
+ (NSString *)getNameWithIndex:(WeekDayMode)index;

@end
