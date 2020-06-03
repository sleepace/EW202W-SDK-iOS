//
//  SLPTCPDelegate.h
//  Sleepace
//
//  Created by Shawley on 14/08/2017.
//  Copyright © 2017 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLPTCPDelegate <NSObject>

- (void)tcpDisconnected:(id)sender;

@optional
- (void)triggerHeartBreath:(id)sender completion:(void (^)(BOOL succeed))completion;

@end
