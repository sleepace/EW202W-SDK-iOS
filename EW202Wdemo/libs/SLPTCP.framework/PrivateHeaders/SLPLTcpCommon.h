//
//  SLPLTcpCommon.h
//  Sleepace
//
//  Created by Martin on 10/26/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SLPLTCPProtocalVersions) {
    SLPLTCPProtocalVersion_0 = 0,//老的协议
    SLPLTCPProtocalVersion_1,//新的协议
};

typedef NS_ENUM(NSInteger,SLPLTCPMessagetUniqTypes) {
#pragma mark Public
    SLPLTCPMessagetUniqType_GetServerIP = 0,//服务器地址查询
    SLPLTCPMessagetUniqType_Login,//登录
    SLPLTCPMessagetUniqType_Heartbeat,//心跳包
    SLPLTCPMessagetUniqType_PublicDeviceAttention,//固件联网状态关注通知
    SLPLTCPMessagetUniqType_HistoryDataUploadFinished,//历史数据上传完成
    SLPLTCPMessagetUniqType_HistoryDataUploadStatus,//历史数据上传状态通知
    SLPLTCPMessagetUniqType_RequestUpdate,//升级请求
    SLPLTCPMessagetUniqType_PostUpdateRate,//升级进度
    // MARK: - Nox
    SLPLTCPMessagetUniqType_NoxSleepAssist,
    SLPLTCPMessagetUniqType_NoxEnvironmentData,
    SLPLTCPMessagetUniqType_NoxAlarmTrigger,
    SLPLTCPMessagetUniqType_NoxSetScene,
    SLPLTCPMessagetUniqType_NoxLightOperation,
    SLPLTCPMessagetUniqType_NoxMusicOperation,
    SLPLTCPMessagetUniqType_NoxPostWorkMode,//nox主动发送的工作信息发生改变
    SLPLTCPMessagetUniqType_NoxGetOperationMode,
    SLPLTCPMessagetUniqType_NoxConfigureAlarm,
    SLPLTCPMessagetUniqType_NoxConfigureAssist,
    SLPLTCPMessagetUniqType_NOXConfigureMultyScene,//多场景配置
    SLPLTCPMessagetUniqType_NoxConfigureSleepScene,
    SLPLTCPMessagetUniqType_NoxConfigureLightScene,
    SLPLTCPMessagetUniqType_NoxConfigureCommonScene,
    SLPLTCPMessagetUniqType_NoxCollectData,
    SLPLTCPMessagetUniqType_PublicGetDeviceOnlineStatus,
    SLPLTCPMessagetUniqType_ClearBattery,
    SLPLTCPMessagetUniqType_RestonOriginalData,
    SLPLTCPMessagetUniqType_NoxConfigure,
    SLPLTCPMessagetUniqType_PublicAttestation,
    SLPLTCPMessagetUniqType_UpdateInfo,
    SLPLTCPMessagetUniqType_RestonAutoCollect,
    SLPLTCPMessagetUniqType_ClockDormant,
    SLPLTCPMessagetUniqType_PublicPostOnlineStatus,
    SLPLTCPMessagetUniqType_RestonBattery,
    SLPLTCPMessagetUniqType_MilkyBattery,
    SLPLTCPMessagetUniqType_MilkyMonitorTime,
    SLPLTCPMessagetUniqType_MilkyCollectInfo,
    SLPLTCPMessagetUniqType_PublicAssistStatus,
    SLPLTCPMessagetUniqType_PublicPostCollectionStatus,
    SLPLTCPMessagetUniqType_NoxRequestCollectionStatus,
    SLPLTCPMessagetUniqType_NoxRequestRealtimeData,//请求实时数据
    SLPLTCPMessagetUniqType_PublicPostRealtimeData,//实时数据报送
    SLPLTCPMessagetUniqType_PublicPostOriginalData,//原始数据
    SLPLTCPMessagetUniqType_NoxNightLightData,  // 小夜灯
    SLPLTCPMessagetUniqType_NoxConfigureAlbum,
    SLPLTCPMessagetUniqType_NoxDeviceInfo,
    // MARK: - Mattress
    SLPLTCPMessagetUniqType_Mattress_StartRealtimeDataNotification,
    SLPLTCPMessagetUniqType_Mattress_StopRealtimeDataNotification,
    SLPLTCPMessagetUniqType_Mattress_StartCollectionDataNotification,
    SLPLTCPMessagetUniqType_Mattress_StopCollectionDataNotification,
    SLPLTCPMessagetUniqType_Mattress_UpgradeStateNotification,
    SLPLTCPMessagetUniqType_Mattress_StartOrignalDataNotification,
    SLPLTCPMessagetUniqType_Mattress_StopOrignalDataNotification,
    
    SLPLTCPMessagetUniqType_Mattress_ConfigureAutoStartCollection,
    SLPLTCPMessagetUniqType_Mattress_GetAutoStartCollectionInfo,
    SLPLTCPMessagetUniqType_Mattress_ConfigureWiFiSetting,
    SLPLTCPMessagetUniqType_Mattress_GetWiFiSetting,
    SLPLTCPMessagetUniqType_Mattress_ConfigureServerAddressSetting,
    SLPLTCPMessagetUniqType_Mattress_GetServerAddressSetting,
    SLPLTCPMessagetUniqType_Mattress_GetMacAddress,
    SLPLTCPMessagetUniqType_Mattress_ConfigureWiFiDromant,
    
    SLPLTCPMessagetUniqType_Mattress_QueryCollectionStatus,
    SLPLTCPMessagetUniqType_Mattress_QueryServiceAddress,
    SLPLTCPMessagetUniqType_Mattress_QueryBatteryInfo,
    SLPLTCPMessagetUniqType_Mattress_QueryWiFiStatus,
    SLPLTCPMessagetUniqType_Mattress_QueryWiFiList,
    SLPLTCPMessagetUniqType_Mattress_QueryDeviceInfo,
    
    SLPLTCPMessagetUniqType_EW202W_TimeCheck,
    SLPLTCPMessagetUniqType_EW202W_GetSystemInfo,
    SLPLTCPMessagetUniqType_EW202W_FactoryReset,
    SLPLTCPMessagetUniqType_EW202W_GetOperatingMode,
    SLPLTCPMessagetUniqType_EW202W_GetAlarmList,
    SLPLTCPMessagetUniqType_EW202W_ConfigAlarm,
    SLPLTCPMessagetUniqType_EW202W_PreViewAlarm,
    SLPLTCPMessagetUniqType_EW202W_LightControl,
    SLPLTCPMessagetUniqType_EW202W_AlarmMusicOperation,
    SLPLTCPMessagetUniqType_EW202W_SetClockDormancyBean,
    SLPLTCPMessagetUniqType_EW202W_GetClockDormancyBean,
    SLPLTCPMessagetUniqType_EW202W_SetAidInfo,
    SLPLTCPMessagetUniqType_EW202W_ConfigSystem,
    SLPLTCPMessagetUniqType_EW202W_GetSystem,
    SLPLTCPMessagetUniqType_EW202W_PostWorkMode,//EW202W主动发送的工作信息发生改变
    SLPlTCPMessagetUniqType_None,
};

enum{
    SLP_LTcp_Error_None = 0x00, //成功
    SLP_LTcp_Error_ServerError = 0x01,//服务器错误
    SLP_LTcp_Error_NotLogin = 0x02,//未登陆
    SLP_LTcp_Error_NoxNotBind = 0x03,//灯未绑定用户
    SLP_LTcp_Error_RestonNotBind = 0x04,//restOn未绑定用户
    SLP_LTcp_Error_RestonBinded = 0x05,//restOn已绑定
    SLP_LTcp_Error_NoxNotOnline = 0x06,//nox不在线
    SLP_LTcp_Error_AppNotOnline = 0x07,//app不在线
    SLP_LTcp_Error_RestonNotOnline = 0x08,//reston不在线
    SLP_LTcp_Error_DataNotFound = 0x09,//请求数据不存在
    SLP_LTcp_Error_PermissionDenied = 0x0a,//权限不足
    SLP_LTcp_Error_OperationFailed = 0x0b,//操作失败
    SLP_LTcp_Error_RestonNotFound = 0x0c,//找不到RestOn
    SLP_LTcp_Error_RestonConnectFailed = 0x0d,//RestOn连接失败
    SLP_LTcp_Error_BluetoothBusy = 0x0e,//蓝牙主模块忙
    SLP_LTcp_Error_IsUpgrade = 0x0f,//正在升级
    SLP_LTcp_Error_ConfigMode = 0x10,//配置模式
    
    SLP_LTcp_Error_UnKnown = 0xff,//未知错误
};

#define kLTCPDefaultTimeoutInterval (10.0)
#define kBLEDefaultConnectTimeoutInterval (10.0)
//获取TCP消息类型的描述
@interface SLPLTcpCommon : NSObject

+ (NSString *)descriptionOfMessagetType:(SLPLTCPMessagetUniqTypes)type;
+ (NSString *)entityClassStringFrom:(SLPLTCPMessagetUniqTypes)type;

#pragma mark 获取网络状态
/**
 *网络是否可达
 */
+ (BOOL)isReachable;

/**
 *网络是否wwan
 */
+ (BOOL)isReachableViaWWAN;
/**
 *网络是否为WiFi
 */
+ (BOOL)isReachableViaWiFi;
@end
