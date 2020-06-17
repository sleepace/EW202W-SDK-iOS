//
//  SettingsViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/13.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "SettingsViewController.h"
#import "AlarmListViewController.h"
#import "TitleSubTitleArrowCell.h"
#import "TitleSwitchCell.h"
#import "AlarmViewController.h"
#import "SLPMinuteSelectView.h"
#import "ClockDormancyViewController.h"
#import <EW202W/SLPLTcpManager+EW202W.h>

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL synServerTime;
@property (nonatomic,assign) NSInteger timeFormat;
@property (nonatomic, strong) SLPClockDormancyBean *bean;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addNotificationObservre];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"brightness %d",SharedDataManager.aidInfo.brightness);

    [self loadData];
    
    [self setUI];
    [self showConnected:SharedDataManager.connected];
    [self.tableView reloadData];
}

- (void)addNotificationObservre {
    NSNotificationCenter *notificationCeter = [NSNotificationCenter defaultCenter];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceConnected:) name:kNotificationNameLTCPConnected object:nil];
    [notificationCeter addObserver:self selector:@selector(tcpDeviceDisconnected:) name:kNotificationNameLTCPDisconnected object:nil];
}

- (void)tcpDeviceConnected:(NSNotification *)notification {
    SharedDataManager.connected = YES;
    [self showConnected:YES];
}

- (void)tcpDeviceDisconnected:(NSNotification *)notification {
    SharedDataManager.connected = NO;
    [self showConnected:NO];
}

- (void)showConnected:(BOOL)connected {
    CGFloat alpha = connected ? 1.0 : 0.3;
    [self.view setAlpha:alpha];
    
    [self.view setUserInteractionEnabled:connected];
}

- (void)loadData
{
    self.timeFormat = SharedDataManager.timeFormat;
    
    self.bean = [SLPClockDormancyBean new];
    self.bean.flag = SharedDataManager.bean.flag;
    self.bean.startHour = SharedDataManager.bean.startHour;
    self.bean.endHour = SharedDataManager.bean.endHour;
    self.bean.startMin = SharedDataManager.bean.startMin;
    self.bean.endMin = SharedDataManager.bean.endMin;

    
    self.synServerTime = SharedDataManager.synServerTime;
    
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager ew202wGetSystemWithDeviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            EW202WSystemInfo *info = data;
            weakSelf.synServerTime = info.netSynFlag;
            SharedDataManager.synServerTime = info.netSynFlag;
            
            weakSelf.timeFormat = info.timeForm;
            SharedDataManager.timeFormat = info.timeForm;
            
            [weakSelf.tableView reloadData];
        }
    }];
    
    [SLPSharedLTcpManager getClockDormancyWithDeviceInfo:SharedDataManager.deviceID timeOut:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SLPClockDormancyBean *info = data;
            weakSelf.bean = info;
            SharedDataManager.bean = info;
            
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"setting");
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 60;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleSubTitleArrowCell *cell = (TitleSubTitleArrowCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSubTitleArrowCell"];
    NSString *title = LocalizedString(@"alarm");
    if(indexPath.row == 1){
        title = LocalizedString(@"time_format");
        cell.subTitleLabel.text = (self.timeFormat == 12) ? LocalizedString(@"time_format_12") : LocalizedString(@"time_format_24");
    }else if(indexPath.row == 2) {
        TitleSwitchCell *switchCell = (TitleSwitchCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSwitchCell"];
        switchCell.switcher.on = self.synServerTime;
        
        __weak typeof(self) weakSelf = self;
        switchCell.switchBlock = ^(UISwitch *sender) {
            [SLPSharedLTcpManager ew202wConfigSystem:1 value:sender.on pincode:@"" deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
                if (status != SLPDataTransferStatus_Succeed) {
                    [weakSelf.tableView reloadData];
                } else {
                    weakSelf.synServerTime = sender.on;
                    SharedDataManager.synServerTime = sender.on;
                }
            }];
        };
        
        [Utils configCellTitleLabel:switchCell.textLabel];
        switchCell.textLabel.text = LocalizedString(@"syn_server_time");
        return switchCell;
    }else if(indexPath.row == 3) {
        title = LocalizedString(@"clock_sleep");
        NSString *value = @"";
        if (self.bean.flag) {
            value = [self getTimeStringWithDataModle:self.bean];
        } else {
            value = LocalizedString(@"close1");
        }
        
        cell.subTitleLabel.text = value;
    }
    [Utils configCellTitleLabel:cell.textLabel];
    [cell.textLabel setText:title];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    if (section == 1) {
        view.backgroundColor = Theme.normalLineColor;
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        UILabel *txtLbl = [[UILabel alloc] init];
        txtLbl.frame = CGRectMake(15, 0, 300, 40);
        txtLbl.text = LocalizedString(@"setGesture");
        txtLbl.font = [UIFont systemFontOfSize:13];
        [view addSubview:txtLbl];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self goAlarmPage];
    }else if (indexPath.row == 1){
        [self showTimeFormatSelector];
    }else if (indexPath.row == 2){
        
    }else if (indexPath.row == 3){
        [self goClockDormancy];
    }
}

- (void)goAlarmPage
{
    AlarmListViewController *vc = [AlarmListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
//    [self goAddAlarm];
}

- (void)goAddAlarm
{
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSInteger alarmID = timeStamp;
    
    AlarmViewController *vc = [AlarmViewController new];
    vc.addAlarmID = alarmID;
//    vc.delegate = self;
    vc.alarmPageType = AlarmPageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goClockDormancy
{
    ClockDormancyViewController *vc = [ClockDormancyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)getTimeStringWithDataModle:(SLPClockDormancyBean *)dataModel {
    NSString *start = [SLPUtils timeStringFrom:dataModel.startHour minute:dataModel.startMin isTimeMode24:(self.timeFormat == 24)];
    NSString *end = [SLPUtils timeStringFrom:dataModel.endHour minute:dataModel.endMin isTimeMode24:(self.timeFormat == 24)];
    return [NSString stringWithFormat:@"%@~%@",start,end];
}

- (void)showTimeFormatSelector
{
    NSArray *values = @[@12,@24];
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:self.view mode:SLPMinutePickerMode_TimeFormat time:self.timeFormat finishHandle:^(NSInteger timeValue) {
        [SLPSharedLTcpManager ew202wConfigSystem:0 value:(timeValue == 12 ? 0 : 1) pincode:@"" deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status == SLPDataTransferStatus_Succeed) {
                weakSelf.timeFormat = timeValue;
                [weakSelf.tableView reloadData];
                SharedDataManager.timeFormat = timeValue;
            }
        }];
    } cancelHandle:nil];
}
@end
