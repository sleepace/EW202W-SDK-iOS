//
//  AlarmViewController.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "BaseViewController.h"

#import <EW202W/EW202W.h>

typedef NS_ENUM(NSInteger, AlarmPageType) {
    AlarmPageType_edit,
    AlarmPageType_Add,
};

@protocol AlarmViewControllerDelegate <NSObject>

@optional
- (void)editAlarmInfoAndShouldReload;
@end
NS_ASSUME_NONNULL_BEGIN

@interface AlarmViewController : BaseViewController

@property (strong, nonatomic) SLPAlarmInfo *orignalAlarmData;

@property (nonatomic, assign) NSInteger addAlarmID;

@property (nonatomic, assign) AlarmPageType alarmPageType;

@property (nonatomic, weak) id<AlarmViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
