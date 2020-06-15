//
//  ClockDormancyViewController.m
//  EW202Wdemo
//
//  Created by Michael on 2020/5/20.
//  Copyright © 2020 medica. All rights reserved.
//

#import "ClockDormancyViewController.h"
#import "TitleSubTitleArrowCell.h"
#import "TitleSwitchCell.h"
#import "TimePickerSelectView.h"
#import "SLPClockFooter.h"

#import "SLPTableSectionData.h"
#import <EW202W/EW202W.h>
#import <SLPCommon/SLPCommon.h>

static NSString *const kSection_SetClock = @"kSection_SetClock";

static NSString *const kRowFlag = @"kRowFlag";
static NSString *const kRowStart = @"kRowStart";
static NSString *const kRowEnd = @"kRowEnd";

@interface ClockDormancyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray <SLPTableSectionData *>* sectionDataList;
@property (nonatomic, strong) SLPClockDormancyBean *bean;
@property (nonatomic,assign) NSInteger timeFormat;

@end

@implementation ClockDormancyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = LocalizedString(@"clock_sleep");
    [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];

    [self loadData];
    
    [self loadSectionData];
}

- (void)loadData
{
    self.bean = [SLPClockDormancyBean new];
    self.bean.flag = SharedDataManager.bean.flag;
    self.bean.startHour = SharedDataManager.bean.startHour;
    self.bean.endHour = SharedDataManager.bean.endHour;
    self.bean.startMin = SharedDataManager.bean.startMin;
    self.bean.endMin = SharedDataManager.bean.endMin;
    
    self.timeFormat = SharedDataManager.timeFormat;
}

- (void)loadSectionData
{
    NSMutableArray *aSectionList = [NSMutableArray array];
    
    SLPTableSectionData *sectionData1 = [[SLPTableSectionData alloc] init];
    sectionData1.sectionEnum = kSection_SetClock;
    NSMutableArray *rowEnumList1 = [NSMutableArray arrayWithObjects:kRowFlag,nil];
//    if (self.alarmDataNew.snoozeTime) {
//        [rowEnumList1 addObject:kRowSnoozeTime];
//    }
    if (self.bean.flag) {
        [rowEnumList1 addObject:kRowStart];
        [rowEnumList1  addObject:kRowEnd];
    }
    sectionData1.rowEnumList = rowEnumList1;
    [aSectionList addObject:sectionData1];
    
    self.sectionDataList = aSectionList;
}

- (IBAction)saveClock:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager configClockDormancy:self.bean deviceInfo:SharedDataManager.deviceID timeOut:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            SharedDataManager.bean = weakSelf.bean;
            
            [Utils showMessage:LocalizedString(@"save_succeed") controller:weakSelf];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:section];
    return sectionData.rowEnumList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SLPClockFooter *footer = [SLPClockFooter footerViewWithTextStr:LocalizedString(@"turn_on_period")];
    footer.backgroundColor = [UIColor whiteColor];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TitleSubTitleArrowCell *cell = (TitleSubTitleArrowCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSubTitleArrowCell"];
    NSString *title = @"";
    if(indexPath.row == 1){
        title = LocalizedString(@"start_time");
        cell.subTitleLabel.text = [SLPUtils timeStringFrom:self.bean.startHour minute:self.bean.startMin isTimeMode24:(self.timeFormat == 24)];
    }else if(indexPath.row == 2) {
        title = LocalizedString(@"end_time");
        cell.subTitleLabel.text = [SLPUtils timeStringFrom:self.bean.endHour minute:self.bean.endMin isTimeMode24:(self.timeFormat == 24)];
    }else if(indexPath.row == 0) {
        TitleSwitchCell *switchCell = (TitleSwitchCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSwitchCell"];
        switchCell.switcher.on = self.bean.flag;
        
        __weak typeof(self) weakSelf = self;
        switchCell.switchBlock = ^(UISwitch *sender) {
            weakSelf.bean.flag = (sender.on ? 1 : 0);
            [weakSelf loadSectionData];
            [weakSelf.tableView reloadData];
        };
        
        [Utils configCellTitleLabel:switchCell.textLabel];
        switchCell.textLabel.text = LocalizedString(@"clock_sleep");
        return switchCell;
    }
    [Utils configCellTitleLabel:cell.textLabel];
    [cell.textLabel setText:title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self showStartTimeSelector];
    } else if (indexPath.row == 2) {
        [self showEndTimeSelector];
    }
}

- (void)showStartTimeSelector
{
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = self.bean.startHour;
    time24.minute = self.bean.startMin;
    
    __weak typeof(self) weakSelf = self;
    TimePickerSelectView *timePick = [TimePickerSelectView timePickerSelectView];
    [timePick showInView:[UIApplication sharedApplication].keyWindow mode:(self.timeFormat == 12) time:time24 finishHandle:^(SLPTime24 * _Nonnull time24) {
        weakSelf.bean.startHour = time24.hour;
        weakSelf.bean.startMin = time24.minute;
        [weakSelf.tableView reloadData];
    } cancelHandle:^{
        
    }];
}

- (void)showEndTimeSelector
{
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = self.bean.endHour;
    time24.minute = self.bean.endMin;
    
    __weak typeof(self) weakSelf = self;
    TimePickerSelectView *timePick = [TimePickerSelectView timePickerSelectView];
    [timePick showInView:[UIApplication sharedApplication].keyWindow mode:(self.timeFormat == 12) time:time24 finishHandle:^(SLPTime24 * _Nonnull time24) {
        weakSelf.bean.endHour = time24.hour;
        weakSelf.bean.endMin = time24.minute;
        [weakSelf.tableView reloadData];
    } cancelHandle:^{
        
    }];
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
