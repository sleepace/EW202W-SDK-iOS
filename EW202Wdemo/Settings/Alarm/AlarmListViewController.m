//
//  AlarmListViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/13.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AlarmListViewController.h"

#import "SLPWeekDay.h"
#import "AlarmDataModel.h"
#import "AlarmViewController.h"
#import "TitleValueSwitchCellTableViewCell.h"
#import <EW202W/EW202W.h>

@interface AlarmListViewController ()<UITableViewDataSource, UITableViewDelegate, AlarmViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLbl;
@property (nonatomic, copy) NSArray *alramList;

@end

@implementation AlarmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    
    [self setUI];
}

- (void)loadData
{
    self.alramList = [NSArray array];
    
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager getAlarmListWithDeviceInfo:SharedDataManager.deviceID  timeout:0 completion:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            weakSelf.alramList = data;
        }
        
        if (weakSelf.alramList && self.alramList.count > 0) {
            weakSelf.tableView.hidden = NO;
            weakSelf.emptyView.hidden = YES;
            [weakSelf.tableView reloadData];
        }else{
            weakSelf.tableView.hidden = YES;
            weakSelf.emptyView.hidden = NO;
            
//            [weakSelf addAlarm];
        }
    }];
}

- (void)addAlarm
{
    SLPAlarmInfo *info = [SLPAlarmInfo new];
    
    info.alarmID = 0;
    info.isOpen = YES;
    info.hour = 8;
    info.minute = 0;
    info.flag = 0;
    info.snoozeTime = 6;
    info.snoozeLength = 9;
    info.volume = 16;
    info.brightness = 100;
    info.musicID = 31098;
    info.timestamp = 0;
    info.enable = YES;
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager alarmConfig:info deviceInfo:@"EW22W20C00044" deviceType:SLPDeviceType_EW202W  timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        NSLog(@"addAlarm------- %ld",(long)status);
        if (status == SLPDataTransferStatus_Succeed) {
            [weakSelf loadData];
        }
    }];
}

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"alarm");
    self.emptyLbl.text = LocalizedString(@"sa_no_alarm");
    [self.addButton setTitle:LocalizedString(@"add") forState:UIControlStateNormal];
    
    if (self.alramList && self.alramList.count > 0) {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
    }else{
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
    }
    
    [Utils configNormalButton:self.addButton];
    [Utils setButton:self.addButton title:LocalizedString(@"add_alarm")];
}

- (IBAction)addAlarm:(id)sender {
    [self goAddAlarm];
}

- (void)goAddAlarm
{
    if (self.alramList.count >= 5) {
        [Utils showMessage:LocalizedString(@"more_5") controller:self];
        return;
    }

    AlarmViewController *vc = [AlarmViewController new];
    vc.addAlarmID = [self requireMixNum];
    vc.delegate = self;
    vc.alarmPageType = AlarmPageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)requireMixNum
{
    NSInteger num = 0;
    
    for (int i = 0; i < 5; i++) {
        NSInteger count = 0;
        for (SLPAlarmInfo *info in self.alramList) {
            if (info.alarmID == i) {
                break;
            }
            
            count ++;
        }
        
        if (count == self.alramList.count) {
            num = i;
            break;
        }
    }
    
    return num;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alramList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleValueSwitchCellTableViewCell *cell = (TitleValueSwitchCellTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"TitleValueSwitchCellTableViewCell"];
    
    SLPAlarmInfo *alarmData = [self.alramList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [self getAlarmTimeStringWithDataModle:alarmData];
    cell.subTitleLbl.text = [SLPWeekDay getAlarmRepeatDayStringWithWeekDay:alarmData.flag];
    cell.switcher.on = alarmData.isOpen;
    
    __weak typeof(self) weakSelf = self;
    cell.switchBlock = ^(UISwitch *sender) {
        if (sender.on) {
            [weakSelf turnOnAlarmWithAlarm:alarmData];
        }else{
            [weakSelf turnOffAlarmWithAlarm:alarmData];
        }
    };
    
    return cell;
}

- (void)turnOnAlarmWithAlarm:(SLPAlarmInfo *)alarmInfo
{
    __weak typeof(self) weakSelf = self;
    alarmInfo.isOpen = YES;
    [SLPSharedLTcpManager alarmConfig:alarmInfo deviceInfo:SharedDataManager.deviceID deviceType:SLPDeviceType_EW202W  timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            alarmInfo.isOpen = NO;
            [weakSelf.tableView reloadData];
        }else{

        }
    }];
}

- (void)turnOffAlarmWithAlarm:(SLPAlarmInfo *)alarmInfo
{
    __weak typeof(self) weakSelf = self;
    alarmInfo.isOpen = NO;
    [SLPSharedLTcpManager alarmConfig:alarmInfo deviceInfo:SharedDataManager.deviceID deviceType:SLPDeviceType_EW202W  timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            alarmInfo.isOpen = YES;
            [weakSelf.tableView reloadData];
        }else{

        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SLPAlarmInfo *alarmData = [self.alramList objectAtIndex:indexPath.row];
    
    [self goAlarmVCWithAlarmData:alarmData];
}

- (void)goAlarmVCWithAlarmData:(SLPAlarmInfo *)alarmData
{
    AlarmViewController *vc = [AlarmViewController new];
    vc.delegate = self;
    vc.orignalAlarmData = alarmData;
    vc.alarmPageType = AlarmPageType_edit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSString *)getAlarmTimeStringWithDataModle:(SLPAlarmInfo *)dataModel {
    NSString *time = [SLPUtils timeStringFrom:dataModel.hour minute:dataModel.minute isTimeMode24:[SLPUtils isTimeMode24]];
    NSString *alarmType = (dataModel.alarmID == 0) ? LocalizedString(@"build_alarm") : LocalizedString(@"");
    return [NSString stringWithFormat:@"%@ -- %@",time,alarmType];
}

- (void)editAlarmInfoAndShouldReload
{
    [self loadData];
}
@end
