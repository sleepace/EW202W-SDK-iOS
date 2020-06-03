//
//  EW202WWorkState.h
//  EW202W
//
//  Created by Michael on 2020/5/13.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BluetoothManager/BluetoothManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface EW202WWorkState : NSObject

@property (nonatomic,assign) UInt8 mode;//工作模式 0: 正常模式 1: 配置模式
@property (nonatomic,assign) UInt8 lightStatus;//灯状态 0: 关闭 1: 照明灯光 2.助眠灯光 3.自定义颜色灯光 4.闹钟灯光

@property (nonatomic,assign) UInt8 brightness;//灯亮度
@property (nonatomic,assign) UInt8 lightMode;//灯光模式 0：暖白 1：冷白 2：红色 3：橙色 4：暖黄 5：绿色 6：青色 7：蓝色 8：紫色 9：流光 0xff：彩色（自定义颜色，需对RGBW进行赋值），如果是0-9可不关注RGBW的值
@property (nonatomic,strong) SLPLight *light;//灯光
@property (nonatomic,assign) UInt8 alarmStatus;//闹钟状态 0x00: 未运行 0x01: 运行中 0x02：贪睡中 0x03: 预览中
@property (nonatomic,assign) UInt8 localAlarmStatus;//本地闹钟开关 0：关 1：开
@property (nonatomic,assign) UInt8 timeMode;//0：12小时制 1：24小时制
@property (nonatomic,assign) UInt8 pincode;//蓝牙PIN码开关 0：关 1开
@property (nonatomic,assign) UInt8 systemBluetooth;//蓝牙开关 0：关 1开
@property (nonatomic,assign) UInt8 syncServerFlag;//时钟网络同步开关 0：关 1开
//@property (nonatomic,assign) UInt8 wifiStatus;//WiFi连接状态 0：未连接 1: 正在连接 2：已连接
@property (nonatomic,assign) UInt8 asssitStaus;//助眠状态 0: 停止 1: 运行中
@property (nonatomic,assign) UInt8 asssitLightStaus;//助眠灯光状态 0: 关 1: 开
@property (nonatomic,assign) UInt8 assistMusicStatus;//助眠音乐状态 0：关 1：开
@property (nonatomic,assign) UInt16 assistMusicID;//助眠音乐ID
@property (nonatomic,assign) UInt8 assistTimeRemained;//助眠剩余时长
@property (nonatomic,assign) UInt32 channelNum;//通道号 0：本地上报 其他：云端或APP请求上报
@end

NS_ASSUME_NONNULL_END
