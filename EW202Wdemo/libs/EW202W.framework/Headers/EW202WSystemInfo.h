//
//  EW202WSystemInfo.h
//  EW202W
//
//  Created by Michael on 2020/6/9.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EW202WSystemInfo : NSObject

@property (nonatomic, assign) UInt8 timeForm;
@property (nonatomic, assign) UInt8 netSynFlag;
@property (nonatomic, assign) UInt8 blueToothFlag;
@property (nonatomic, assign) UInt8 pinFlag;
@property (nonatomic, strong) NSString *pincode;

@end

NS_ASSUME_NONNULL_END
