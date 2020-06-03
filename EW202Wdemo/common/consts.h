//
//  consts.h
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#ifndef consts_h
#define consts_h

#define kScreenSize ([[UIScreen mainScreen] bounds].size)
#define kPortraitScreenSize (kScreenSize.width>kScreenSize.height?CGSizeMake(kScreenSize.height, kScreenSize.width):kScreenSize)
#define kStatusBarHeight (20.0)
#define kNavigationBarHeight (44.0)

//屏幕大小
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width

enum {
    E_HistoryDataType_24HourData = 0,
    E_HistoryDataType_History,
    E_HistoryDataType_Demo,
};
#endif /* consts_h */
