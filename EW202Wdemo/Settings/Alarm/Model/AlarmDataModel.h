//
//  AlarmDataModel.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger snoozeRangeDefaultValue = 5;
static const NSInteger snoozeRangePhoneDefaultValue = 9;

NS_ASSUME_NONNULL_BEGIN

@interface AlarmDataModel : NSObject

//闹铃编号
@property (nonatomic,copy)NSString *alarmSeqid;
//闹铃是否已开启
@property (nonatomic,assign)BOOL isOpen;
//时
@property (nonatomic,assign)NSInteger hour;
//分
@property (nonatomic,assign)NSInteger minute;
//闹铃重复 (数组7个BOOL元素代表7天,YES:重复 NO:不重复)排序:日六五四三二一
@property (nonatomic,readonly)NSMutableArray *repeatTimeArr;
//是否仅使用一次的闹铃
@property (nonatomic,readonly,assign)BOOL isUseOneTime;

//音乐编号
@property (nonatomic,assign)NSInteger musicSeqid;

//智能唤醒
@property (nonatomic, assign) BOOL smartFlag;

//唤醒时间范围(分钟)
@property (nonatomic,assign)NSInteger awakeRange;

//贪睡时长
@property (nonatomic,assign)NSInteger snoozeRange;
//是否贪睡
@property (nonatomic, assign) BOOL snoozeFlag;

//十进制数字
@property (nonatomic, copy) NSString *weekday;
//香薰唤醒
@property (nonatomic, assign) BOOL aromaFlag;

//灯光唤醒
@property (nonatomic, assign) BOOL lightFlag;

@end

NS_ASSUME_NONNULL_END
