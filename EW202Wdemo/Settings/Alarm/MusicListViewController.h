//
//  MusicListViewController.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FromMode) {
    FromMode_SleepAid,
    FromMode_Alarm,
};

typedef void(^SelectMusicBlock)(NSInteger musicID);

@interface MusicListViewController : BaseViewController

@property (nonatomic, assign) NSInteger musicID;

@property (nonatomic, copy) NSArray *musicList;

@property (nonatomic, copy) SelectMusicBlock musicBlock;

@property (nonatomic, assign) FromMode mode;

@end

NS_ASSUME_NONNULL_END
