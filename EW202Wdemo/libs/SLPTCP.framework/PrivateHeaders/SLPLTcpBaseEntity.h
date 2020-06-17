//
//  SLPLTcpBaseEntity.h
//  Sleepace
//
//  Created by Martin on 10/27/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPTcpCommonHeads.h"
#import "SLPLTcpDef.h"

@interface SLPLTcpBaseEntity : NSObject
@property (nonatomic,assign) NSInteger messageType;
@property (nonatomic,assign) UInt16 status;
@property (nonatomic,assign) SLPLTCPMessagetUniqTypes uniqType;
@property (nonatomic,readonly) BOOL isSucceed;
@property (nonatomic,readonly) BOOL isInConfig;

+ (SLPLTcpBaseEntity *)entityWithTCPData:(NSData *)data;
- (id)initWithTCPData:(NSData *)data;

- (NSString *)statusDescription;

//无参数的消息使用
+ (NSData *)content;

//检测是否还有其他的用处
//设备 -> APP post的消息在此处理
- (void)checkReuseableFor:(id)sender;
@end
