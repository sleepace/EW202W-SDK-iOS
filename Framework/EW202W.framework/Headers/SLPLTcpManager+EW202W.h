//
//  SLPLTcpManager+EW202W.h
//  EW202W
//
//  Created by Michael on 2020/5/12.
//  Copyright © 2020 Martin. All rights reserved.
//

#import <SLPTCP/SLPTCP.h>
#import "EW202WDeviceInfo.h"
#import "EW202WWorkState.h"
#import "EW202WAlarmInfo.h"
#import "EW202WClockDormancyBean.h"
#import "EW202WAidInfo.h"
#import "EW202WSystemInfo.h"
#import <SLPCommon/SLPCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPLTcpManager (EW202W)

/**
 获取设备信息
 @param deviceName 设备名称
 @param deviceType 设备类型
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)ew202wGetDeviceInfo:(NSString *)deviceName deviceType:(SLPDeviceTypes)deviceType timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 设备初始化
 @param deviceName 设备名称
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)ew202wDeviceInitWithDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;


/**
 工作状态查询
 @param deviceName 设备名称
 @param timeout 超时（单位秒）
 @param handle 回调 data类型为EW202WWorkState
 */
- (void)ew202wGetWorkStatusWithDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 闹铃预览，退出预览
 @param deviceName 设备名称
 @param volume 音量大小 闹钟最大音量(0-16) 0:静音
 @param brightness 灯光亮度 灯光最大亮度(0-100) 0:不亮
 @param operation 预览操作 0：关 1：开
 @param musicID 音乐编号
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)ew202wAlarmRreviewOperationVolume:(UInt8)volume brightness:(UInt8)brightness operation:(UInt8)operation musicID:(UInt16)musicID deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 灯光控制
 @param deviceName 设备名称
 @param operation 0：关灯 1开灯 2调节亮度
 @param brightness 灯光亮度
 @param lightMode 颜色编号 0：暖白 1：冷白 2：红色 3：橙色 4：暖黄 5：绿色 6：青色 7：蓝色 8：紫色 9：流光
 0xff：彩色（自定义颜色，需对RGBW进行赋值），如果是0-9可不关注RGBW的值
 @param light 灯光
 @param timeout 超时（单位秒）
 @param handle 回调
 */
- (void)ew202wLightControlOperation:(UInt8)operation brightness:(UInt8)brightness lightMode:(UInt8)lightMode light:(SLPLight *)light deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 闹钟音乐控制
 @param deviceName 设备名称
 @param operation 操作码 0：停止 1播放 2调节音量
 @param musicID 音乐ID
 @param volume 音量大小 闹钟最大音量(0-16) 0:静音
 @param timeout 超时（单位秒）
 @param handle 回调
 */

- (void)ew202wAlarmMusicOperation:(UInt8)operation musicID:(UInt16)musicID volume:(UInt8)volume deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 系统设置
 @param deviceName 设备名称
 @param operation 操作 0：时间制式 1：网络同步时间开关 2：蓝牙开关 4: 蓝牙PIN码开关
 @param value 操作 对应的操作的值：时间制式 0:12小时制 1:24小时制
                               时间同步 0：关闭 1：打开
                               蓝牙开关 0：关闭 1：打开
                               蓝牙PIN开关0：关闭 1：打开
 @param pincode PIN码 PIN码开关打开后次字段才生效，最大长度不超过16
 @param timeout 超时（单位秒）
 @param handle 回调
*/

- (void)ew202wConfigSystem:(UInt8)operation value:(UInt8)value pincode:(NSString *)pincode deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 系统信息查询
 @param deviceName 设备名称
 @param timeout 超时（单位秒）
 @param handle 回调 data类型为EW202WSystemInfo
*/
- (void)ew202wGetSystemWithDeviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 助眠操作
 @param deviceName 设备名称
 @param aidInfo 助眠信息
 @param timeout 超时（单位秒）
 @param handle 回调
 */

- (void)ew202wConfigAidInfo:(SLPAidInfo *)aidInfo deviceInfo:(NSString *)deviceName timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 助眠配置获取
 @param deviceName 设备名称
 @param timeout 超时（单位秒）
 @param handle 回调
*/
- (void)ew202wGetAidInfoWithDeviceInfo:(NSString *)deviceName timeOut:(CGFloat)timeout callback:(SLPTransforCallback)handle;

@end


NS_ASSUME_NONNULL_END
