//
//  ConfigWIFIViewController.m
//  EW202Wdemo
//
//  Created by Michael on 2020/5/19.
//  Copyright © 2020 medica. All rights reserved.
//

#import "ConfigWIFIViewController.h"
#import <SLPTCP/SLPTCP.h>
#import <EW202W/EW202W.h>

@interface ConfigWIFIViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UITextField *tokenTextField;

@property (nonatomic, weak) IBOutlet UILabel *selectDeviceIDLabel;
@property (nonatomic, weak) IBOutlet UITextField *selectDeviceIDTextField;
@property (nonatomic, weak) IBOutlet UIImageView *selectDeviceIDArrow;

@property (nonatomic, weak) IBOutlet UILabel *serverIPLabel;
@property (nonatomic, weak) IBOutlet UITextField *serverIP;
@property (nonatomic, weak) IBOutlet UITextField *serverPort;

@property (nonatomic, weak) IBOutlet UILabel *serverWIFILabel;
@property (nonatomic, weak) IBOutlet UITextField *serverWIFIName;
@property (nonatomic, weak) IBOutlet UITextField *serverWIFIPassword;

@property (nonatomic, weak) IBOutlet UIButton *configButton;

@end

@implementation ConfigWIFIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.titleLabel.text = LocalizedString(@"distribution_network");
    
    SLPSharedLTcpManager;

//    [self addNotificationObservre];
}

- (void)setUI {
    if (SharedDataManager.token) {
        self.tokenTextField.text = SharedDataManager.token;
    }
    
    if (SharedDataManager.deviceID) {
        self.selectDeviceIDTextField.text = SharedDataManager.deviceID;
    }
    
    if (SharedDataManager.serverIP) {
        self.serverIP.text = SharedDataManager.serverIP;
    }
    
    if (SharedDataManager.serverPort) {
        self.serverPort.text = SharedDataManager.serverPort;
    }
    if (SharedDataManager.wifiName) {
        self.serverWIFIName.text = SharedDataManager.wifiName;
    }
    if (SharedDataManager.password) {
        self.serverWIFIPassword.text = SharedDataManager.password;
    }
    [Utils configSectionTitle:self.selectDeviceIDLabel];
    [Utils configSectionTitle:self.serverIPLabel];
    [Utils configSectionTitle:self.serverWIFILabel];
    
    [Utils configNormalButton:self.configButton];
    [Utils setButton:self.configButton title:LocalizedString(@"start_network")];

    self.selectDeviceIDLabel.text = LocalizedString(@"select_id1");
    self.serverIPLabel.text = LocalizedString(@"server_information");
    self.serverWIFILabel.text = LocalizedString(@"select_wifi");
    
    self.selectDeviceIDTextField.placeholder = LocalizedString(@"device_id");
    self.serverIP.placeholder = LocalizedString(@"server_ip");
    self.serverPort.placeholder = LocalizedString(@"server_port");
    self.serverWIFIName.placeholder = LocalizedString(@"input_wifi_name");
    self.serverWIFIPassword.placeholder = LocalizedString(@"input_wifi_psw");

    self.selectDeviceIDArrow.image = [UIImage imageNamed:@"common_list_icon_leftarrow"];

    self.serverPort.keyboardType = UIKeyboardTypeNumberPad;
    
    self.selectDeviceIDTextField.delegate = self;
    self.serverIP.delegate = self;
    self.serverPort.delegate = self;
    self.serverWIFIName.delegate = self;
    self.serverWIFIPassword.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUI];
}

- (IBAction)configWIFI:(id)sender
{    
    if (![self checkInputAvaliable]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    [loadingView setText:LocalizedString(@"start_network")];
    [[SLPBleWifiConfig sharedBleWifiConfig] configPeripheral:SharedDataManager.peripheral deviceType:SLPDeviceType_EW202W serverAddress:self.serverIP.text port:self.serverPort.text.integerValue wifiName:self.serverWIFIName.text password:self.serverWIFIPassword.text completion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            [SLPSharedLTcpManager loginDeviceID:SharedDataManager.deviceID completion:^(SLPDataTransferStatus status, id data) {
                if (status == SLPDataTransferStatus_Succeed) {
                    SharedDataManager.connected = YES;
                    [[NSUserDefaults standardUserDefaults] setValue:self.serverIP.text forKey:@"serverIP"];
                    [[NSUserDefaults standardUserDefaults] setValue:self.serverPort.text forKey:@"serverPort"];
                    [[NSUserDefaults standardUserDefaults] setValue:self.serverWIFIName.text forKey:@"serverWIFIName"];
                    [[NSUserDefaults standardUserDefaults] setValue:self.serverWIFIPassword.text forKey:@"serverWIFIPassword"];

                    SharedDataManager.serverIP = self.serverIP.text;
                    SharedDataManager.serverPort = self.serverPort.text;
                    SharedDataManager.wifiName = self.serverWIFIName.text;
                    SharedDataManager.password = self.serverWIFIPassword.text;

                    [Utils showMessage:LocalizedString(@"connection_succeeded") controller:self];
                } else {
                    [Utils showMessage:LocalizedString(@"Connection_failed") controller:self];
                }
                [weakSelf unshowLoadingView];
            }];
        } else {
            [weakSelf unshowLoadingView];
            [Utils showMessage:LocalizedString(@"Connection_failed") controller:self];
        }
    }];
}

- (BOOL)checkInputAvaliable
{
    BOOL avaliable = YES;
    
    if (!self.selectDeviceIDTextField.text.length || !self.serverIP.text.length || !self.serverPort.text.length || !self.serverWIFIName.text.length || !self.serverWIFIPassword.text.length) {
        avaliable = NO;
        [Utils showAlertTitle:nil message:LocalizedString(@"information_empty") confirmTitle:LocalizedString(@"confirm") atViewController:self];
    }
    
    return avaliable;
}

- (IBAction)install:(id)sender
{
    __weak typeof(self) weakSelf = self;
    if (self.tokenTextField.text.length > 0) {
        [SLPSharedLTcpManager installSDKWithToken:self.tokenTextField.text ip:@"http://172.14.1.100:9080" channelID:63100 timeout:0 completion:^(SLPDataTransferStatus status, id data) {
            if (status == SLPDataTransferStatus_Succeed) {
                [Utils showMessage:LocalizedString(@"connection_succeeded") controller:self];
                SharedDataManager.token = weakSelf.tokenTextField.text;
            } else {
                [Utils showMessage:LocalizedString(@"Connection_failed") controller:self];
            }
        }];
    } else {
        [Utils showAlertTitle:nil message:LocalizedString(@"information_empty") confirmTitle:LocalizedString(@"confirm") atViewController:self];
    }
}

- (IBAction)goConnectDevice:(id)sender
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
                return;
    }
    [Coordinate pushViewControllerName:@"SearchViewController" sender:self animated:YES];
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    if(![string isEqualToString:blank]) {
        return NO;
    }
    
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符

        if (textField == self.serverIP) {
            if ((single < '0' || single > '9') && single != '.') {//数据格式正确
                return NO;
            }
        }
    }
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
