//
//  DataManager.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DataManager.h"
#define kUserID @"kUserID"
@implementation DataManager

+ (DataManager *)sharedDataManager {
    static dispatch_once_t onceToken;
    static DataManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init]) {
        _selectItemsNum = 7;
        _assistMusicID = 30086;
        
        _aidInfo = [[SLPAidInfo alloc] init];
        _aidInfo.aidStopDuration = 1;
        _aidInfo.r = 255;
        _aidInfo.b = 0;
        _aidInfo.g = 0;
        _aidInfo.w = 0;
        _aidInfo.brightness = 0;
        _aidInfo.aidStopDuration = 45;
        _aidInfo.volume = 0;
        _aidInfo.musicID = 31131;
        _aidInfo.lightFlag = 1;
        _volumn = 0;
        
        _alarmList = [NSMutableArray array];
        
        _timeFormat = 12;
        _synServerTime = YES;
        
        _bean = [SLPClockDormancyBean new];
        _bean.startHour = 22;
        _bean.startMin = 0;
        _bean.endHour = 7;
        _bean.endMin = 0;
        _bean.flag = 0;
        
        _deviceID = @"";
        _token = @"";
        _channelID = @"";
        _plat = @"";
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"serverIP"]) {
            _serverIP = [[NSUserDefaults standardUserDefaults] valueForKey:@"serverIP"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"serverPort"]) {
            _serverPort = [[NSUserDefaults standardUserDefaults] valueForKey:@"serverPort"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"serverWIFIName"]) {
            _wifiName = [[NSUserDefaults standardUserDefaults] valueForKey:@"serverWIFIName"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"serverWIFIPassword"]) {
            _password = [[NSUserDefaults standardUserDefaults] valueForKey:@"serverWIFIPassword"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"deviceID"]) {
            _deviceID = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceID"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"token"]) {
            _token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"plat"]) {
            _plat = [[NSUserDefaults standardUserDefaults] valueForKey:@"plat"];
        }
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"channelID"]) {
            _channelID = [[NSUserDefaults standardUserDefaults] valueForKey:@"channelID"];
        }
    }
    
    return self;
}

- (void)reset
{
    _selectItemsNum = 7;
    _assistMusicID = 31131;
    
    _aidInfo.aidStopDuration = 1;
    _aidInfo.r = 255;
    _aidInfo.b = 0;
    _aidInfo.w = 0;
    _aidInfo.brightness = 0;
//    _aidInfo.aromaRate = 2;
    _volumn = 0;
}

- (void)toInit {
    self.peripheral = nil;
    self.deviceName = nil;
    self.deviceID = nil;
    self.inRealtime = NO;
    
}

- (NSString *)userID {
    NSString *userIDString = [[NSUserDefaults standardUserDefaults] stringForKey:kUserID];
    return userIDString;
}

- (void)setUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:kUserID];
}
@end
