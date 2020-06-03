//
//  WeekdaySelectViewController.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectWeekdayBlock)(NSInteger weekday);

@interface WeekdaySelectViewController : BaseViewController

@property (nonatomic, assign) NSInteger selectWeekDay;

@property (nonatomic, copy) SelectWeekdayBlock weekdayBlock;

@end

NS_ASSUME_NONNULL_END
