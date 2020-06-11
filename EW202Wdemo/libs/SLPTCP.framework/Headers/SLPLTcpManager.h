//
//  SLPLTcpManager.h
//  Sleepace
//
//  Created by Martin on 10/26/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPLTcp.h"


#define SLPSharedLTCP [SLPLTcpManager sharedLTCPManager].lTcp
#define SLPSharedLTcpManager [SLPLTcpManager sharedLTCPManager]

@class SLPLTcpServer;
@interface SLPLTcpManager : NSObject
{
}
@property (nonatomic,readonly) SLPConnectStatus status;
@property (nonatomic,assign) BOOL enable;
@property (nonatomic,readonly) SLPLTcp *lTcp;
@property (nonatomic,readonly) NSString *deviceID;
@property (nonatomic,readonly) NSString *sid;
@property (nonatomic,readonly) NSString *ip;
@property (nonatomic,readonly) NSString *port;
@property (nonatomic,readonly) NSString *channel;

+ (instancetype)sharedLTCPManager;

- (void)toInit;

//登录
- (BOOL)loginDeviceID:(NSString *)deviceID  completion:(SLPTransforCallback)handle;

//初始化SDK
- (void)installSDKWithToken:(NSString *)token ip:(NSString *)ip channelID:(NSInteger)channelID timeout:(CGFloat)timeoutInterval completion:(SLPTransforCallback)handle;

//绑定
- (void)bindDevice:(NSString *)deviceID leftRight:(NSInteger)leftRight  timeout:(CGFloat)timeoutInterval completion:(SLPTransforCallback)handle;

//解绑
- (void)unBindDevice:(NSString *)deviceID leftRight:(NSInteger)leftRight  timeout:(CGFloat)timeoutInterval completion:(SLPTransforCallback)handle;


- (void)getBindDevice:(NSString *)deviceID  timeout:(CGFloat)timeoutInterval completion:(SLPTransforCallback)handle;

- (void)getDeviceWithChannelId:(NSString *)channelId lan:(NSString *)lan  timeout:(CGFloat)timeoutInterval completion:(SLPTransforCallback)handle;


/**
 时钟休眠设置
 @param deviceName 设备名称
 @param clockDormancyBean 时钟休眠信息
 @param timeout 超时（单位秒）
 @param handle 回调
 */

- (void)configClockDormancy:(SLPClockDormancyBean *)clockDormancyBean deviceInfo:(NSString *)deviceName  timeOut:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 时钟休眠获取
 @param deviceName 设备名称
 @param timeout 超时（单位秒）
 @param handle 回调
 */

- (void)getClockDormancyWithDeviceInfo:(NSString *)deviceName  timeOut:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 获取闹钟列表
 @param deviceName 设备名称
 @param timeout 超时（单位秒）
 @param handle 回调 返回 NSArray<SABAlarmInfo *>
 */
- (void)getAlarmListWithDeviceInfo:(NSString *)deviceName  timeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;

/**
 添加，修改和删除闹铃
 @param deviceName 设备名称
 @param alarmInfo 闹钟信息
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)alarmConfig:(SLPAlarmInfo *)alarmInfo deviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType  timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*固件升级通知
deviceID           :设备ID
deviceType         :设备类型
firmwareType       :固件类型
0:无效    1:开发
2:测试    3:发布
firmwareVersion    :最新固件版本号
*/
- (void)publicUpdateOperationWithDeviceID:(NSString *)deviceID
                               deviceType:(SLPDeviceTypes)deviceType
                             firmwareType:(UInt8)firmwareType
                          firmwareVersion:(NSString *)version
                                  timeout:(CGFloat)timeout
                               completion:(SLPTransforCompletion)handle;


@end
