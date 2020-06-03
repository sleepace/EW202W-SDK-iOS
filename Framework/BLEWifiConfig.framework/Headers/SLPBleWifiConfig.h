//
//  SLPBleWifiConfig.h
//  SDK
//
//  Created by Martin on 2018/1/25.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BluetoothManager/BluetoothManager.h>

@class CBPeripheral;
@interface SLPBleWifiConfig : NSObject

@property (nonatomic , readonly) CBPeripheral *peripheral;

+ (SLPBleWifiConfig *)sharedBleWifiConfig;

- (void)connectAndGetDeviceInfoWithPeripheral:(CBPeripheral *)peripheral
               deviceType:(SLPDeviceTypes)deviceType
               completion:(void(^)(SLPDataTransferStatus status, id data))completion;

- (void)configPeripheral:(CBPeripheral *)peripheral deviceType:(SLPDeviceTypes)deviceType
           serverAddress:(NSString *)address port:(NSInteger)port
                wifiName:(NSString *)name
                password:(NSString *)password
              completion:(void(^)(SLPDataTransferStatus status, id data))completion;

- (void)configPeripheral:(CBPeripheral *)peripheral deviceType:(SLPDeviceTypes)deviceType
                wifiName:(NSString *)name
                password:(NSString *)password
              completion:(void(^)(SLPDataTransferStatus status, id data))completion;


@end
