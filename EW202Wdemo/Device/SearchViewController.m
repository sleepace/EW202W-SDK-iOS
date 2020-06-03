//
//  SearchViewController.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "SearchViewController.h"

#import <BLEWifiConfig/BLEWifiConfig.h>
enum {
    Section_Title = 0,
    Section_Device,
    Section_Bottom
};

enum {
    SectionTitleRow_title = 0,
    SectionTitleRow_Btn,
    
    SectionTitleRow_Bottom
};

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SLPPeripheralInfo *> *deviceList;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceList = [NSMutableArray array];
    [self setUI];
    
    [self scan];
}

- (void)setUI {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = LocalizedString(@"search_ble");
}

- (void)appendPeripheralInfo: (SLPPeripheralInfo *)info {
    if (info.name.length == 0) {
        return;
    }
    
//    if (![info.name hasPrefix:@"SN21"]) {
//        return;
//    }
    for (SLPPeripheralInfo *aInfo in self.deviceList) {
        if ([info.name isEqualToString:aInfo.name]) {
            return;
        }
    }
    [self.deviceList addObject:info];
    [self.tableView reloadData];
}

- (void)scan {
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    
    [self.deviceList removeAllObjects];
    [self.tableView reloadData];
    __weak typeof(self) weakSelf = self;
    BOOL ret = [SLPBLESharedManager scanBluetoothWithTimeoutInterval:3.0 completion:^(SLPBLEScanReturnCodes code, NSInteger handleID, SLPPeripheralInfo *peripheralInfo) {
        if (code == SLPBLEScanReturnCode_Normal) {
            [weakSelf appendPeripheralInfo:peripheralInfo];
        }else if (code == SLPBLEScanReturnCode_Disable) {
            [Utils showDeviceOperationFailed:-4 atViewController:weakSelf];
        }
    }];
    
    if (!ret) {
        [Utils showDeviceOperationFailed:-4 atViewController:weakSelf];
    }
}

- (void)connectDevice:(SLPPeripheralInfo *)info {
    __weak typeof(self) weakSelf = self;
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:LocalizedString(@"phone_bluetooth_not_open") controller:self];
        return;
    }
    SLPLoadingBlockView *loadingView = [self showLoadingView];
    [loadingView setText:LocalizedString(@"Connecting")];
    [[SLPBleWifiConfig sharedBleWifiConfig] connectAndGetDeviceInfoWithPeripheral:info.peripheral deviceType:SLPDeviceType_EW202W completion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SLPDeviceInfo *deviceInfo = data;
            SharedDataManager.deviceID = deviceInfo.deviceID;
            [[NSUserDefaults standardUserDefaults] setObject:deviceInfo.deviceID forKey:@"deviceID"];
            SharedDataManager.deviceName = info.name;
            SharedDataManager.peripheral = info.peripheral;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
        [weakSelf unshowLoadingView];
    }];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return Section_Bottom;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = SectionTitleRow_Bottom;
    if (section == Section_Device) {
        row = self.deviceList.count;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [Utils configCellTitleLabel:cell.textLabel];
    }
    
    cell.accessoryView = nil;
    NSInteger row = indexPath.row;
    
    NSString *title = @"";
    switch (indexPath.section) {
        case Section_Title:
            switch (row) {
                case Section_Title:
                    title = LocalizedString(@"select_id");
                    break;
                case Section_Device:
                {
                    title = LocalizedString(@"click_refresh");
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
                    [imageView setImage:[UIImage imageNamed:@"device_btn_refresh_nor.png"]];
                    cell.accessoryView = imageView;
                }
                    break;
                default:
                    break;
            }
            break;
        case Section_Device:
        {
            SLPPeripheralInfo *info = [self.deviceList objectAtIndex:row];
            title = info.name;
        }
            break;
        default:
            break;
    }
    [cell.textLabel setText:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ret = YES;
    if (indexPath.section == Section_Title && indexPath.row == SectionTitleRow_title) {
        ret = NO;
    }
    return ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == Section_Device) {
        [self connectDevice:[self.deviceList objectAtIndex:indexPath.row]];
    }else{
        [self scan];
    }
}
@end
