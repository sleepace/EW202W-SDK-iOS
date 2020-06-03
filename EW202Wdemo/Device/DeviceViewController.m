//
//  DeviceViewController.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "DeviceViewController.h"
#import "SearchViewController.h"

#import <SLPTCP/SLPLTcpDef.h>
#import <SLPTCP/SLPLTcpUpgradeInfo.h>
#import "DatePickerPopUpView.h"

@interface DeviceViewController ()<UITextFieldDelegate>
{
    SLPTimer *progressTimer;///是否收到升级进度超时定时器
}
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *userIDShell;
@property (nonatomic, weak) IBOutlet UILabel *userIDTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *userIDLabel;
//deviceInfo
@property (nonatomic, weak) IBOutlet UITextField *ipTextField;
@property (nonatomic, weak) IBOutlet UITextField *tokenTextField;
@property (nonatomic, weak) IBOutlet UIButton *connectBtn;
@property (nonatomic, weak) IBOutlet UIView *deviceInfoShell;
@property (nonatomic, weak) IBOutlet UILabel *deviceInfoSectionLabel;
@property (nonatomic, weak) IBOutlet UIButton *getDeviceNameBtn;
@property (nonatomic, weak) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *getDeviceIDBtn;
@property (nonatomic, weak) IBOutlet UILabel *deviceIDLabel;
@property (nonatomic, weak) IBOutlet UIButton *getBatteryBtn;
@property (nonatomic, weak) IBOutlet UILabel *batteryLabel;
@property (nonatomic, weak) IBOutlet UIButton *getMacBtn;
@property (nonatomic, weak) IBOutlet UILabel *macLabel;
//firmwareInfo
@property (nonatomic, weak) IBOutlet UITextField *deviceIDTextField;
@property (nonatomic, weak) IBOutlet UITextField *firmwareVersionTextField;
@property (nonatomic, weak) IBOutlet UIButton *upgradeBtn;
@property (nonatomic, weak) IBOutlet UIView *firmwareInfoShell;
@property (nonatomic, weak) IBOutlet UILabel *firmwareInfoSectionLabel;
@property (nonatomic, weak) IBOutlet UIButton *getFirmwareVersionBtn;
@property (nonatomic, weak) IBOutlet UILabel *firmwareVersionLabel;

//setting
@property (nonatomic, weak) IBOutlet UIView *settingShell;
@property (nonatomic, weak) IBOutlet UILabel *settingSectionLabel;
@property (nonatomic, weak) IBOutlet UIView *alarmUpLine;
@property (nonatomic, weak) IBOutlet UILabel *alarmTitleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *alarmEnableSwitch;
@property (nonatomic, weak) IBOutlet UIView *alarmDownLine;
@property (nonatomic, weak) IBOutlet UILabel *alarmTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *alarmTimeIcon;
@property (nonatomic, weak) IBOutlet UIView *alarmTimeDownLine;

@property (nonatomic, assign) BOOL connected;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"device");
    
    [self setUI];
    [self addNotificationObservre];
}

- (void)setUI {
    [Utils configNormalButton:self.connectBtn];
    [Utils configNormalButton:self.getDeviceNameBtn];
    [Utils configNormalButton:self.getDeviceIDBtn];
    [Utils configNormalButton:self.getBatteryBtn];
    [Utils configNormalButton:self.getFirmwareVersionBtn];
    [Utils configNormalButton:self.getMacBtn];
    [Utils configNormalButton:self.upgradeBtn];
    
    [Utils configNormalDetailLabel:self.deviceNameLabel];
    [Utils configNormalDetailLabel:self.deviceIDLabel];
    [Utils configNormalDetailLabel:self.batteryLabel];
    [Utils configNormalDetailLabel:self.firmwareVersionLabel];
    [Utils configNormalDetailLabel:self.macLabel];
    
    [Utils configSectionTitle:self.userIDTitleLabel];
    [Utils configSectionTitle:self.deviceInfoSectionLabel];
    [Utils configSectionTitle:self.firmwareInfoSectionLabel];
    [Utils configSectionTitle:self.settingSectionLabel];
    
    self.ipTextField.placeholder = LocalizedString(@"server_ip");
    self.tokenTextField.placeholder = LocalizedString(@"token");
    self.deviceIDTextField.placeholder = LocalizedString(@"device_id");
    self.firmwareVersionTextField.placeholder = LocalizedString(@"固件版本");
    self.ipTextField.text = @"http://172.14.1.100:9080";
    self.deviceIDTextField.text = @"EW22W20C00045";
    if (SharedDataManager.token.length > 0) {
        self.tokenTextField.text = SharedDataManager.token;
    } else {
        self.tokenTextField.text = @"kylhm2tu62sw";
    }
    
    self.ipTextField.delegate = self;
    self.tokenTextField.delegate = self;
    self.deviceIDTextField.delegate = self;
    self.firmwareVersionTextField.delegate = self;

    [Utils setButton:self.getDeviceNameBtn title:LocalizedString(@"device_id_clear")];
    [Utils setButton:self.getDeviceIDBtn title:LocalizedString(@"device_id_cipher")];
    [Utils setButton:self.getBatteryBtn title:LocalizedString(@"obtain_electricity")];
    [Utils setButton:self.getFirmwareVersionBtn title:LocalizedString(@"obtain_firmware")];
    [Utils setButton:self.getMacBtn title:LocalizedString(@"obtain_mac_address")];
    [Utils setButton:self.upgradeBtn title:LocalizedString(@"fireware_update")];
    [Utils setButton:self.connectBtn title:LocalizedString(@"connect_device")];

    [self.alarmTitleLabel setText:LocalizedString(@"apnea_alert")];
    [self.alarmTimeLabel setText:LocalizedString(@"set_alert_switch")];
    [self.alarmTimeIcon setImage:[UIImage imageNamed:@"common_list_icon_leftarrow.png"]];

    [self.userIDTitleLabel setText:LocalizedString(@"userid_sync_sleep")];
    [self.deviceInfoSectionLabel setText:LocalizedString(@"device_infos")];
    [self.firmwareInfoSectionLabel setText:LocalizedString(@"firmware_info")];
    [self.settingSectionLabel setText:LocalizedString(@"setting")];
    
    [self.alarmUpLine setBackgroundColor:Theme.normalLineColor];
    [self.alarmDownLine setBackgroundColor:Theme.normalLineColor];
    [self.alarmTimeDownLine setBackgroundColor:Theme.normalLineColor];
    
    [Utils configCellTitleLabel:self.alarmTitleLabel];
    [Utils configCellTitleLabel:self.alarmTimeLabel];
    
    self.userIDLabel.keyboardType = UIKeyboardTypeNumberPad;
    [self.userIDLabel setTextColor:Theme.C3];
    [self.userIDLabel setFont:Theme.T3];
    
    [self.userIDLabel.layer setMasksToBounds:YES];
    [self.userIDLabel.layer setCornerRadius:2.0];
    [self.userIDLabel.layer setBorderWidth:1.0];
    [self.userIDLabel.layer setBorderColor:Theme.normalLineColor.CGColor];
    [self.userIDLabel setText:[DataManager sharedDataManager].userID];
    [self.userIDLabel setPlaceholder:LocalizedString(@"enter_userid")];
}

- (void)showConnected:(BOOL)connected {
    CGFloat shellAlpha = connected ? 1.0 : 0.3;
    [self.deviceInfoShell setAlpha:shellAlpha];
    [self.firmwareInfoShell setAlpha:shellAlpha];
    [self.settingShell setAlpha:shellAlpha];
    
    [self.deviceInfoShell setUserInteractionEnabled:connected];
    [self.firmwareInfoShell setUserInteractionEnabled:connected];
    [self.settingShell setUserInteractionEnabled:connected];
    
    if (!connected) {
        [self.deviceNameLabel setText:nil];
        [self.deviceIDLabel setText:nil];
        [self.batteryLabel setText:nil];
        [self.firmwareVersionLabel setText:nil];
        [Utils setButton:self.connectBtn title:LocalizedString(@"connect_device")];
    }else{
        [Utils setButton:self.connectBtn title:LocalizedString(@"disconnect")];
    }
    [Utils setButton:self.connectBtn title:LocalizedString(@"connect_device")];
    [self.settingShell setUserInteractionEnabled:connected];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.deviceIDLabel setText:SharedDataManager.deviceID];
//    [self.deviceNameLabel setText:SharedDataManager.deviceName];
//    [self showConnected:SharedDataManager.connected];
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    [notificationCeter addObserver:self selector:@selector(blueToothIsOpen:) name:kNotificationNameBLEEnable object:nil];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceConnected:) name:kNotificationNameLTCPConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceDisconnected:) name:kNotificationNameLTCPDisconnected object:nil];
}

- (void)blueToothIsOpen:(NSNotification *)notification
{

    
}

- (void)tcpDeviceConnected:(NSNotification *)notification {
    self.connected = YES;
    SharedDataManager.connected = YES;
//    [self showConnected:YES];
}

- (void)tcpDeviceDisconnected:(NSNotification *)notification {
    self.connected = NO;
    SharedDataManager.connected = NO;
//    [self showConnected:NO];
}

- (IBAction)getDeviceNameClicked:(id)sender {
    [self.deviceNameLabel setText:SharedDataManager.deviceName];
}

- (IBAction)getDeviceIDClicked:(id)sender {
    [self.deviceIDLabel setText:SharedDataManager.deviceName];
}

-(IBAction)connectDevice:(id)sender {
    if (self.deviceIDTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"设备ID不能为空") controller:self];
        return;
    }
    if (self.ipTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"服务器地址不能为空") controller:self];
        return;
    }
    if (self.tokenTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"token不能为空") controller:self];
        return;
    }
    
    [SLPSharedLTcpManager.lTcp disconnectCompletion:nil];
    
    SharedDataManager.deviceID = self.deviceIDTextField.text;

    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager installSDKWithToken:self.tokenTextField.text ip:self.ipTextField.text thirdPlatform:@"123456987" channelID:63100 timeout:0 completion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SharedDataManager.token = weakSelf.tokenTextField.text;
            [[NSUserDefaults standardUserDefaults] setValue:weakSelf.tokenTextField.text forKey:@"token"];
            
            NSString *str = SharedDataManager.deviceID;
            NSLog(@"deviceID ---- %@",str);
            [SLPSharedLTcpManager loginDeviceID:SharedDataManager.deviceID loginHost:@"172.14.1.100" port:9010 token:@"" channelID:@"" completion:^(SLPDataTransferStatus status, id data) {
                if (status == SLPDataTransferStatus_Succeed) {
                    SharedDataManager.connected = YES;
                    [Utils showMessage:LocalizedString(@"连接成功") controller:self];
                } else {
                    [Utils showMessage:LocalizedString(@"连接失败") controller:self];
                }
                [weakSelf unshowLoadingView];
            }];
            
        } else {
            [Utils showMessage:LocalizedString(@"失败") controller:weakSelf];
        }
    }];
}

- (IBAction)getDeviceVerionClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    
    [[SLPBleWifiConfig sharedBleWifiConfig] connectAndGetDeviceInfoWithPeripheral:SharedDataManager.peripheral deviceType:SLPDeviceType_EW202W completion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SLPDeviceInfo *deviceInfo = data;
            SharedDataManager.version = deviceInfo.version;
            [self.firmwareVersionLabel setText:deviceInfo.version];
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
        [weakSelf unshowLoadingView];
    }];
}

- (IBAction)upgradeClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    if (self.firmwareVersionTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"请输入固件版本") controller:self];
        return;
    }
    
    if (self.deviceIDTextField.text.length == 0 && SharedDataManager.deviceID.length == 0) {
        [Utils showMessage:LocalizedString(@"请输入设备ID") controller:self];
        return;
    }
    
    if (self.deviceIDTextField.text.length != 0) {
        SharedDataManager.deviceID = self.deviceIDTextField.text;
    }
    
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    [loadingView setText:LocalizedString(@"upgrading")];
    
    [SLPSharedLTcpManager publicUpdateOperationWithDeviceID:SharedDataManager.deviceID deviceType:SLPDeviceType_EW202W firmwareType:1 firmwareVersion:1.01 timeout:0 completion:^(SLPDataTransferReturnStatus status, id data) {
        if (status == SLPDataTransferReturnStatus_Succeed)///通知升级成功（获取进度)
        {
            ///接收nox升级进度
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTCPUpgradeProgress:) name:kNotificationNameNoxUpdateRateChanged object:nil];
            //是否接受nox升级进度超时定时器
            progressTimer=[SLPTimer scheduledTimerWithTimeInterval:20.0 target:self  userInfo:nil repeats:NO handle:^(SLPTimer * _Nonnull timer) {
                [weakSelf unshowLoadingView];
                [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
            }];
        }
        else///通知升级失败
        {
            [weakSelf unshowLoadingView];
            [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
        }
    }];
//    [SLPBLESharedManager bleNox:SharedDataManager.peripheral deviceUpgrade:data timeout:0 callback:^(SLPDataTransferStatus status, id data) {
//        if (status != SLPDataTransferStatus_Succeed){
//            [weakSelf unshowLoadingView];
//            [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
//        }else{
//            BleNoxUpgradeInfo *info = data;
//            [loadingView setText:[NSString stringWithFormat:@"%2d%%", (int)(info.progress * 100)]];
//            if (info.progress == 1) {
//                [weakSelf unshowLoadingView];
//                [Utils showMessage:LocalizedString(@"up_success") controller:weakSelf];
//            }
//        }
//    }];
}

////更新nox升级进度
- (void)updateTCPUpgradeProgress:(NSNotification*)progressNoti
{
    SLPLoadingBlockView *loadingView = [self showLoadingView];

    NSDictionary *userInfo = progressNoti.userInfo;
    SLPLTcpUpgradeInfo *info=[userInfo objectForKey:kNotificationPostData];
    
    [progressTimer invalidate];//销毁进度条定时器
    ///再次创建定时器,如果进度条停顿则超时，升级失败
    __weak typeof(self) weakSelf = self;
    progressTimer=[SLPTimer scheduledTimerWithTimeInterval:20.0 target:self  userInfo:nil repeats:NO handle:^(SLPTimer * _Nonnull timer) {
        [weakSelf unshowLoadingView];
        [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
    }];
    
    switch (info.updateStatus) {
        case 0:///正在升级
        {
            [loadingView setText:[NSString stringWithFormat:@"%2d%%", (int)(info.rate)]];
        }
            break;
        case 1://升级成功
        {
            [weakSelf unshowLoadingView];
            [Utils showMessage:LocalizedString(@"up_success") controller:weakSelf];
            [progressTimer invalidate];//销毁进度条定时器
            [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationNameNoxUpdateRateChanged object:nil];///移除进度通知
        }
            break;
        case 2://升级失败
        {
            [weakSelf unshowLoadingView];
            [Utils showMessage:LocalizedString(@"up_failed") controller:weakSelf];
            [progressTimer invalidate];//销毁进度条定时器
            [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationNameNoxUpdateRateChanged object:nil];///移除进度通知
        }
            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    if(![string isEqualToString:blank]) {
        return NO;
    }
    
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符

        if (textField == self.firmwareVersionTextField) {
            if ((single < '0' || single > '9') && single != '.') {//数据格式正确
                return NO;
            }
        }
    }
    
    return YES;
}
@end
