//
//  DataManager.h
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <EW202W/EW202W.h>

#define SharedDataManager [DataManager sharedDataManager]
@class CBPeripheral;
@interface DataManager : NSObject
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, assign) BOOL inRealtime;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *plat;
@property (nonatomic, strong) NSString *channelID;

@property (nonatomic, assign) NSInteger selectItemsNum;

@property (nonatomic, assign) NSInteger assistMusicID;

@property (nonatomic, assign) NSInteger volumn;

@property (nonatomic, strong) SLPAidInfo *aidInfo;

@property (nonatomic, assign) int waveAction;

@property (nonatomic, assign) int hoverAction;

@property (nonatomic, strong) NSMutableArray *alarmList;

@property (nonatomic, assign) NSInteger timeFormat;

@property (nonatomic, strong) SLPClockDormancyBean *bean;

@property (nonatomic, assign) BOOL synServerTime;

@property (nonatomic, strong) NSString *serverIP;
@property (nonatomic, strong) NSString *serverPort;
@property (nonatomic, strong) NSString *wifiName;
@property (nonatomic, strong) NSString *password;


+ (DataManager *)sharedDataManager;

- (void)toInit;

- (void)reset;
@end
