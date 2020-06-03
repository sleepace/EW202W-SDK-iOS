//
//  SLPLTcpBaseSubParser.h
//  Sleepace
//
//  Created by Martin on 11/18/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPLTcpReceivePacket.h"
//#import "SLPLTcpCommon.h"
#import "SLPTcpCommonHeads.h"

@interface SLPLTcpBaseSubParser : NSObject
+ (SLPLTcpReceivePacket *) packetWithData:(NSData *)data;

//通道号
+ (UInt32)channelIDFromData:(NSData *)data;
//帧类型
+ (SLPFramTypes)framTypeFromData:(NSData *)data;
//帧数目
+ (UInt16)framNumberFromData:(NSData *)data;
//帧编号
+ (UInt16)framIndexFromData:(NSData *)data;
//帧序号
+ (UInt16)messageSequecenFrom:(NSData *)data;
//CRC32
+ (BOOL)checkCRC32:(NSData *)data;

//设备类型
+ (SLPDeviceTypes)deviceTypeFromData:(NSData *)data;
//消息类型
+ (UInt16)messageTypeFromData:(NSData *)data;
//内容
+ (NSData *)contentFromData:(NSData*)data;

//子包的消息载体
+ (NSData *)subPacketHeadFromData:(NSData *)data;
+ (NSData *)subPacketContentFromData:(NSData *)data;
+ (NSData *)subPacketTailFromData:(NSData *)data;
@end
