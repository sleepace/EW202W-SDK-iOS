//
//  SLPTime24.m
//  Profession
//
//  Created by Martin on 4/7/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPTime24.h"
#import "SLPTime12.h"

@implementation SLPTime24

- (id)initWithSLPTime24:(SLPTime24 *)time24{
    if (self = [super init]){
        self.hour = time24.hour;
        self.minute = time24.minute;
    }
    return self;
}

- (SLPTime12 *)convertToTime12{
    SLPTime12 *time12 = [[SLPTime12 alloc] init];
    time12.minute = self.minute;
    time12.second = self.second;
    
    NSInteger hour = self.hour;
    BOOL isAM = YES;
    
    if (hour == 0){
        hour = 12;
        isAM = YES;
    }else if (hour >= 1 && hour <= 11){
        hour = self.hour;
        isAM = YES;
    }else if (hour == 12){
        hour = self.hour;
        isAM = NO;
    }else {
        hour = self.hour%12;
        isAM = NO;
    }
    time12.hour = hour;
    time12.isAM = isAM;
    
    return time12;
}

- (NSString *)timeStringWithFormat:(SLP_Time_String_Format)format{
    NSString *timeString = [NSString stringWithFormat:@"%02d:%02d",(int)self.hour,(int)self.minute];
    if (format == SLP_Time_String_Format_HMS){
        timeString = [NSString stringWithFormat:@"%@:%02d",timeString,(int)self.second];
    }
    return timeString;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%d:%d:%d",(int)self.hour,(int)self.minute,(int)self.second];
}


- (BOOL)isEqualToTime:(SLPTime24 *)time{
    BOOL ret = time.hour == self.hour && time.minute == self.minute;
    return ret;
}

+ (SLPTime24 *)time24WithTimeString:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = hour;
    time24.minute = minute;
    return time24;
}

@end
