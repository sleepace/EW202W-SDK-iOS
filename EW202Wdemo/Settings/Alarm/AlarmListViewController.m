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
    [SLPSharedLTcpManager ew202wGetAlarmListWithDeviceInfo:SharedDataManager.deviceID timeout:0 completion:^(SLPDataTransferStatus status, id data) {
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
    
    NSInteger alarmID = self.alramList.count;
    
    AlarmViewController *vc = [AlarmViewController new];
    vc.addAlarmID = alarmID;
    vc.delegate = self;
    vc.alarmPageType = AlarmPageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alramList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleValueSwitchCellTableViewCell *cell = (TitleValueSwitchCellTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"TitleValueSwitchCellTableViewCell"];
    
    EW202WAlarmInfo *alarmData = [self.alramList objectAtIndex:indexPath.row];
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

- (void)turnOnAlarmWithAlarm:(EW202WAlarmInfo *)alarmInfo
{
    __weak typeof(self) weakSelf = self;
    alarmInfo.isOpen = YES;
    [SLPSharedLTcpManager ew202wAlarmConfig:alarmInfo deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            alarmInfo.isOpen = NO;
            [weakSelf.tableView reloadData];
        }else{

        }
    }];
}

- (void)turnOffAlarmWithAlarm:(EW202WAlarmInfo *)alarmInfo
{
    __weak typeof(self) weakSelf = self;
    alarmInfo.isOpen = NO;
    [SLPSharedLTcpManager ew202wAlarmConfig:alarmInfo deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
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
    
    EW202WAlarmInfo *alarmData = [self.alramList objectAtIndex:indexPath.row];
    
    [self goAlarmVCWithAlarmData:alarmData];
}

- (void)goAlarmVCWithAlarmData:(EW202WAlarmInfo *)alarmData
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

- (NSString *)getAlarmTimeStringWithDataModle:(EW202WAlarmInfo *)dataModel {
    return [SLPUtils timeStringFrom:dataModel.hour minute:dataModel.minute isTimeMode24:[SLPUtils isTimeMode24]];
}

- (void)editAlarmInfoAndShouldReload
{
    [self loadData];
}
@end
