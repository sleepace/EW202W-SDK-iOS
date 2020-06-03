//
//  SLPLTcpUpgradeInfo.h
//  SLPTCP
//
//  Created by Michael on 2020/5/26.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPLTcpUpgradeInfo : NSObject

@property (nonatomic,copy) NSString *deviceID;
@property (nonatomic,assign) NSInteger deviceType;
//0:正在升级 1:升级成功 2:升级失败
@property (nonatomic,assign) NSInteger updateStatus;
//升级进度    UINT8 进度 0-100%
@property (nonatomic,assign) NSInteger rate;

@end

NS_ASSUME_NONNULL_END
