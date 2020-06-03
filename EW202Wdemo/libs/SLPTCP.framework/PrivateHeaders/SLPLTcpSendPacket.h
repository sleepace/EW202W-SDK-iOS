//
//  SLPLTcpSendPacket.h
//  Sleepace
//
//  Created by Martin on 10/27/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPTcpCommonHeads.h"

@class SLPLTcpSendPacket;
@protocol SLPLTcpSendPacketDelegate <NSObject>
//超时
- (void)sendPacketTimeout:(SLPLTcpSendPacket *)sender;

@end

@interface SLPLTcpSendPacket : NSObject
@property (nonatomic,weak) id<SLPLTcpSendPacketDelegate> delegate;

@property (nonatomic,strong) NSString *deviceID;//设备ID
@property (nonatomic,assign) UInt32 channelID;//通道号: 变更为作设备ID使用
@property (nonatomic,assign) SLPLTCPProtocalVersions protocalType;//协议类型 对应版本
@property (nonatomic,assign) SLPFramTypes framType;//帧类型
//@property (nonatomic,assign) NSInteger framNumber;//帧数目
//@property (nonatomic,assign) NSInteger framIndex;//帧序号
@property (nonatomic,readonly) NSInteger sequence;//消息序号
@property (nonatomic,assign) NSInteger messageType;//消息类型
@property (nonatomic,strong) NSData *content;//纯内容，一些参数

//这个是新协议才会用到~
@property (nonatomic,assign) SLPDeviceTypes deviceType;//设备类型

//控制用的
//自定义的消息类型~ 和LCTP的消息一一对应
@property (nonatomic,assign) SLPLTCPMessagetUniqTypes uniqMessageType;
@property (nonatomic,assign) CGFloat timeout;//超时时间
@property (nonatomic,copy) SLPTransforCompletion completion;

+ (SLPLTcpSendPacket *)packetWithUniqMessageType:(SLPLTCPMessagetUniqTypes)uniqType framType:(SLPFramTypes)framType protocal:(SLPLTCPProtocalVersions)protocal messageType:(NSInteger)messageType timeout:(CGFloat)timeout
                             completion:(SLPTransforCompletion)handle;

- (NSData *)packet;

- (void)fire;
- (void)invalidate;
@end
