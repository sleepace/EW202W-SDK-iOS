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

+ (instancetype)sharedLTCPManager;

- (void)toInit;

//初始化SDK
- (void)installSDKWithToken:(NSString *)token ip:(NSString *)ip  thirdPlatform:(NSString *)platform channelID:(NSInteger)channelID timeout:(CGFloat)timeoutInterval completion:(SLPTransforCallback)handle;

//登录
- (BOOL)loginDeviceID:(NSString *)deviceID loginHost:(NSString *)host port:(NSInteger)port token:(NSString *)token channelID:(NSString *)channelID completion:(SLPTransforCallback)handle;

/*固件升级通知
deviceID           :设备ID
deviceType         :设备类型
firmwareType       :固件类型
0:无效    1:开发
2:测试    3:发布
firmwareVersion    :最新固件版本号
*/
- (void)publicUpdateOperationWithDeviceID:(NSString *)deviceID deviceType:(SLPDeviceTypes)deviceType firmwareType:(UInt8)firmwareType firmwareVersion:(UInt16)version timeout:(CGFloat)timeout completion:(SLPTransforCompletion)handle;


@end
