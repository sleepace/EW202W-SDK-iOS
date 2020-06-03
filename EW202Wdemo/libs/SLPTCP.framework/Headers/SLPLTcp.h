//
//  SLPLTcp.h
//  Sleepace
//
//  Created by Martin on 10/26/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPTCPDelegate.h"
#import <SLPCommon/SLPCommon.h>

@class SLPLTcpParser;
@class SLPLTcpSendPacket;
@interface SLPLTcp : NSObject
{
    SLPLTcpParser *mParser;
    NSMutableArray<SLPLTcpSendPacket *> *mSendPacketList;
    UInt32 mChannelID;//通道号
}
@property (nonatomic,weak) id<SLPTCPDelegate>delegate;

- (void)toInit;
- (void)sendPacket:(SLPLTcpSendPacket *)packet;
- (void)disconnectCompletion:(void(^)(void))completion;
- (void)connect:(NSString *)host port:(NSInteger)port completion:(void(^)(BOOL succeed))completion;

@end
