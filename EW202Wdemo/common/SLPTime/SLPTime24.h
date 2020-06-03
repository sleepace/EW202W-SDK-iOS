//
//  SLPTime24.h
//  Profession
//
//  Created by Martin on 4/7/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPTime.h"

//24小时制
@class SLPTime12;
@interface SLPTime24 : NSObject
@property (nonatomic,assign) NSInteger hour;
@property (nonatomic,assign) NSInteger minute;
@property (nonatomic,assign) NSInteger second;

- (id)initWithSLPTime24:(SLPTime24 *)time24;
- (SLPTime12 *)convertToTime12;
- (NSString *)timeStringWithFormat:(SLP_Time_String_Format)format;

- (BOOL)isEqualToTime:(SLPTime24 *)time;

+ (SLPTime24 *)time24WithTimeString:(NSString *)timeString;
@end
