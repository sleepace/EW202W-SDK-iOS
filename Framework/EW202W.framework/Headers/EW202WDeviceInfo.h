//
//  EW202WDeviceInfo.h
//  EW202W
//
//  Created by Michael on 2020/5/13.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EW202WDeviceInfo : NSObject

@property (nonatomic, copy) NSString *deviceID;//设备ID
@property (nonatomic, assign) NSString *firmwareVersion;//固件版本

@end

NS_ASSUME_NONNULL_END
