//
//  SLPHTTPManager.h
//  SDK
//
//  Created by Michael on 2020/5/28.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SLPAidInfo.h"
#import "SLPClockDormancyBean.h"
#import "SLPDataTransferDef.h"
#import "SLPAlarmInfo.h"
NS_ASSUME_NONNULL_BEGIN

#define SLPSharedHTTPManager [SLPHTTPManager sharedInstance]

@interface SLPHTTPManager : NSObject

@property (nonatomic,readonly) NSString *httpIP;
@property (nonatomic,readonly) NSString *sid;

+(id)sharedInstance;

//
- (void)installSDKWithToken:(NSString *)token ip:(NSString *)ip channelID:(NSInteger)channelID timeout:(CGFloat)timeoutInterval completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)bindDevice:(NSString *)deviceID leftRight:(NSInteger)leftRight  timeout:(CGFloat)timeoutInterval completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)unBindDevice:(NSString *)deviceID leftRight:(NSInteger)leftRight  timeout:(CGFloat)timeoutInterval completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)getBindDevice:(NSString *)deviceID  timeout:(CGFloat)timeoutInterval completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)getDeviceVersionWithChannelId:(NSString *)channelId lan:(NSString *)lan  timeout:(CGFloat)timeoutInterval completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)configAidInfo:(SLPAidInfo *)aidInfo deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)getAidInfoWithDeviceInfo:(NSString *)deviceName  timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)configClockDormancy:(SLPClockDormancyBean *)clockDormancyBean deviceInfo:(NSString *)deviceName  timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)getClockDormancyWithDeviceInfo:(NSString *)deviceName  timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)getAlarmListWithDeviceInfo:(NSString *)deviceName  timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

- (void)alarmConfig:(SLPAlarmInfo *)alarmInfo deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeOut:(CGFloat)timeout completion:(void (^)(BOOL result,id responseObject, NSString *error))completion;

@end

NS_ASSUME_NONNULL_END
