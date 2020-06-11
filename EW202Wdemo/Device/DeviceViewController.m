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
@property (nonatomic, weak) IBOutlet UITextField *channelTextField;
@property (nonatomic, weak) IBOutlet UITextField *platTextField;

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
    
    self.ipTextField.placeholder = LocalizedString(@"server_ip");
    self.tokenTextField.placeholder = LocalizedString(@"token");
    self.channelTextField.placeholder = LocalizedString(@"ChannelID");

    self.deviceIDTextField.placeholder = LocalizedString(@"device_id");
    self.firmwareVersionTextField.placeholder = LocalizedString(@"target_version");
    self.ipTextField.text = @"http://172.14.0.111:8082";
    self.deviceIDTextField.text = @"EW22W20C00045";
    if (SharedDataManager.token.length > 0) {
        self.tokenTextField.text = SharedDataManager.token;
    } else {
        self.tokenTextField.text = @"kylhm2tu62sw";
//        self.tokenTextField.text = @"r8xfa7hdjcm6";
    }
    self.channelTextField.text = @"13700";
    if (SharedDataManager.channelID.length > 0) {
        self.channelTextField.text = SharedDataManager.channelID;
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
    [Utils setButton:self.connectBtn title:LocalizedString(@"connect_server")];


    [self.userIDTitleLabel setText:LocalizedString(@"userid_sync_sleep")];
    [self.deviceInfoSectionLabel setText:LocalizedString(@"device_infos")];
    [self.firmwareInfoSectionLabel setText:LocalizedString(@"firmware_info")];
        
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceConnected:) name:kNotificationNameLTCPConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceDisconnected:) name:kNotificationNameLTCPDisconnected object:nil];
}

- (void)tcpDeviceConnected:(NSNotification *)notification {
    self.connected = YES;
    SharedDataManager.connected = YES;
}

- (void)tcpDeviceDisconnected:(NSNotification *)notification {
    self.connected = NO;
    SharedDataManager.connected = NO;
}

- (IBAction)getDeviceNameClicked:(id)sender {
    [self.deviceNameLabel setText:SharedDataManager.deviceName];
}

- (IBAction)getDeviceIDClicked:(id)sender {
    [self.deviceIDLabel setText:SharedDataManager.deviceName];
}

-(IBAction)connectDevice:(id)sender {
    if (self.deviceIDTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"id_cipher") controller:self];
        return;
    }
    if (self.ipTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"server_http") controller:self];
        return;
    }
    if (self.tokenTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"enter_token") controller:self];
        return;
    }
    if (self.channelTextField.text.length == 0) {
        [Utils showMessage:LocalizedString(@"enter_id") controller:self];
        return;
    }
    
    [SLPSharedLTcpManager.lTcp disconnectCompletion:nil];
    
    SharedDataManager.deviceID = self.deviceIDTextField.text;

    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager installSDKWithToken:self.tokenTextField.text ip:self.ipTextField.text channelID:self.channelTextField.text.intValue timeout:0 completion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SharedDataManager.token = weakSelf.tokenTextField.text;
            [[NSUserDefaults standardUserDefaults] setValue:weakSelf.tokenTextField.text forKey:@"token"];
            
            NSString *str = SharedDataManager.deviceID;
            NSLog(@"deviceID ---- %@",str);
            [[NSUserDefaults standardUserDefaults] setValue:self.channelTextField.text forKey:@"channelID"];

            SharedDataManager.channelID = self.channelTextField.text;
            
            [SLPSharedLTcpManager loginDeviceID:SharedDataManager.deviceID completion:^(SLPDataTransferStatus status, id data) {
                if (status == SLPDataTransferStatus_Succeed) {
                    SharedDataManager.connected = YES;
                    [Utils showMessage:LocalizedString(@"connection_succeeded") controller:self];
                } else {
                    [Utils showMessage:LocalizedString(@"Connection_failed") controller:self];
                }
                [weakSelf unshowLoadingView];
            }];
            
        } else {
            [Utils showMessage:LocalizedString(@"Connection_failed") controller:weakSelf];
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
        [Utils showMessage:LocalizedString(@"target_version") controller:self];
        return;
    }
    
    if (self.deviceIDTextField.text.length == 0 && SharedDataManager.deviceID.length == 0) {
        [Utils showMessage:LocalizedString(@"id_cipher") controller:self];
        return;
    }
    
    if (self.deviceIDTextField.text.length != 0) {
        SharedDataManager.deviceID = self.deviceIDTextField.text;
    }
    
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    [loadingView setText:LocalizedString(@"upgrading")];
    
    [SLPSharedLTcpManager publicUpdateOperationWithDeviceID:SharedDataManager.deviceID deviceType:SLPDeviceType_EW202W firmwareType:1 firmwareVersion:self.firmwareVersionTextField.text timeout:0 completion:^(SLPDataTransferReturnStatus status, id data) {
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
