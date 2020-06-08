//
//  AlarmViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AlarmViewController.h"

#import "SLPTableSectionData.h"
#import "TitleSwitchCell.h"
#import "SLPWeekDay.h"
#import "SLPViewInfo.h"
#import "SLPLabelFooter.h"
#import "SLPAlarmFooter.h"
#import "SLPMinuteSelectView.h"
#import "WeekdaySelectViewController.h"
#import "MusicListViewController.h"
#import "TitleSubTitleArrowCell.h"
#import "MusicInfo.h"
#import "TimePickerSelectView.h"



static NSString *const kSection_SetDeviceInfo = @"kSection_SetDeviceInfo";

static NSString *const kRowTime = @"kRowTime";
static NSString *const kRowRepeat = @"kRowRepeat";
static NSString *const kRowMusic = @"kRowMusic";
static NSString *const kRowMusicVolumn = @"kRowMusicVolumn";
static NSString *const kRowLightWake = @"kRowLightWake";
//static NSString *const kRowSmartWake = @"kRowSmartWake";
//static NSString *const kRowWakeTime = @"kRowWakeTime";

static NSString *const kRowSnooze = @"kRowSnooze";
static NSString *const kRowSnoozeTime = @"kRowSnoozeTime";

@interface AlarmViewController ()<UITableViewDataSource, UITableViewDelegate, SLPAlarmFooterDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray <SLPTableSectionData *>* sectionDataList;

//section的footer
@property (nonatomic, strong) NSMutableArray<SLPViewInfo *> *sectionFooterList;

@property (nonatomic,strong) SLPAlarmFooter *alarmFooter;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) NSMutableArray *musicList;

@property (strong, nonatomic) SLPAlarmInfo *alarmDataNew;

@end

@implementation AlarmViewController

-(NSMutableArray *)musicList{
    if (!_musicList) {
        _musicList = [NSMutableArray array];
        
        MusicInfo *musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31098;
        musicInfo.musicName = LocalizedString(@"alarm_list_1");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31099;
        musicInfo.musicName = LocalizedString(@"alarm_list_3");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31100;
        musicInfo.musicName = LocalizedString(@"dididi");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31101;
        musicInfo.musicName = LocalizedString(@"music_box");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31102;
        musicInfo.musicName = LocalizedString(@"alarm_list_9");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31103;
        musicInfo.musicName = LocalizedString(@"alarm_list_7");
        [_musicList addObject:musicInfo];
    }
    
    return _musicList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self loadSectionData];
    
    [self createFooterList];
}

- (void)setUI
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 0.001)];
    self.tableView.tableHeaderView = view;
    self.alarmDataNew = [[SLPAlarmInfo alloc] init];
    if (self.alarmPageType == AlarmPageType_Add) {
        self.titleLabel.text = LocalizedString(@"add_alarm");
        
        [self initDefaultAlarmData];
    }else{
        self.titleLabel.text = LocalizedString(@"edit_alarm");
        
        [self initAlarmDataWithOriginal];
    }
    
    [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];
}

- (void)initAlarmDataWithOriginal
{
    self.alarmDataNew.alarmID = self.orignalAlarmData.alarmID;
    self.alarmDataNew.isOpen = self.orignalAlarmData.isOpen;
    self.alarmDataNew.hour = self.orignalAlarmData.hour;
    self.alarmDataNew.minute = self.orignalAlarmData.minute;
    self.alarmDataNew.flag = self.orignalAlarmData.flag;
    self.alarmDataNew.snoozeTime = self.orignalAlarmData.snoozeTime;
    self.alarmDataNew.snoozeLength = self.orignalAlarmData.snoozeLength;
    self.alarmDataNew.volume = self.orignalAlarmData.volume;
    self.alarmDataNew.brightness = self.orignalAlarmData.brightness;
    self.alarmDataNew.musicID = self.orignalAlarmData.musicID;
//    self.alarmDataNew.aromaRate = self.orignalAlarmData.aromaRate;
    self.alarmDataNew.timestamp = [[NSDate date] timeIntervalSince1970];
    self.alarmDataNew.enable = self.orignalAlarmData.enable;
}

- (void)initDefaultAlarmData
{
    self.alarmDataNew.alarmID = self.addAlarmID;
    self.alarmDataNew.isOpen = true;
    self.alarmDataNew.hour = 8;
    self.alarmDataNew.minute = 0;
    self.alarmDataNew.flag = 0;
    self.alarmDataNew.snoozeTime = 6;
    self.alarmDataNew.snoozeLength = 9;
    self.alarmDataNew.volume = 16;
    self.alarmDataNew.brightness = 100;
    self.alarmDataNew.musicID = 31098;
//    self.alarmDataNew.aromaRate = 2;
    self.alarmDataNew.timestamp = [[NSDate date] timeIntervalSince1970];
    self.alarmDataNew.enable = 1;
}

- (void)loadSectionData
{
    NSMutableArray *aSectionList = [NSMutableArray array];
    
    SLPTableSectionData *sectionData1 = [[SLPTableSectionData alloc] init];
    sectionData1.sectionEnum = kSection_SetDeviceInfo;
    NSMutableArray *rowEnumList1 = [NSMutableArray arrayWithObjects:kRowTime, kRowRepeat, kRowMusic, kRowMusicVolumn, kRowLightWake, kRowSnooze, kRowSnoozeTime, nil];
//    if (self.alarmDataNew.snoozeTime) {
//        [rowEnumList1 addObject:kRowSnoozeTime];
//    }
    sectionData1.rowEnumList = rowEnumList1;
    [aSectionList addObject:sectionData1];
    
    self.sectionDataList = aSectionList;
}

//SLPAlarmFooter
- (void)createFooterList{
    //section的数目
    self.sectionFooterList = [NSMutableArray array];
    NSInteger sectionNumber = self.sectionDataList.count;
    for (SLPTableSectionData *section in self.sectionDataList) {
        NSInteger index = [self.sectionDataList indexOfObject:section];
        SLPViewInfo *info = nil;
        if (index == sectionNumber - 1) {//最后一个
            info = [self createLastFooterForSectionName:section.sectionEnum];
        }else{
            info = [self createUnLastFooterForSectionName:section.sectionEnum];
        }
        [self.sectionFooterList addObject:info];
    }
}

- (SLPViewInfo *)createUnLastFooterForSectionName:(NSString *)sectionName {
//    NSString *tip = LocalizedString(@"");
    SLPLabelFooter *footer = [SLPLabelFooter footerViewWithTextStr:@""];
    [footer setHidden:NO];
    SLPViewInfo *info = [SLPViewInfo new];
    [info setView:footer];
    [info setHeight:[SLPLabelFooter footerHeight:@""]];
    return info;
}

- (SLPViewInfo *)createLastFooterForSectionName:(NSString *)sectionName {
    NSString *tip = [NSString stringWithFormat:LocalizedString(@""), LocalizedString(@"")];
    
    UIView *view = nil;
    CGFloat height = 0;
    SLPAlarmFooter *footer = [SLPAlarmFooter footerViewWithTextStr:tip];
    footer.backgroundColor = [UIColor whiteColor];
    self.alarmFooter = footer;
    [footer setDelegate:self];
    view = footer;
    
    if (self.alarmPageType == AlarmPageType_Add || self.alarmDataNew.alarmID == 0){
        [footer.deleteBtn setHidden:YES];
    }else {
        [footer.deleteBtn setHidden:NO];
    }
    height = [footer height];
    
    SLPViewInfo *info = [SLPViewInfo new];
    [info setView:view];
    [info setHeight:height];
    return info;
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowName = [sectionData .rowEnumList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self getTableCellWithRowName:rowName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    SLPViewInfo *viewInfo = [self.sectionFooterList objectAtIndex:section];
    return viewInfo.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SLPViewInfo *viewInfo = [self.sectionFooterList objectAtIndex:section];
    return viewInfo.view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowName = [sectionData.rowEnumList objectAtIndex:indexPath.row];
    if ([rowName isEqualToString:kRowTime]) {
        [self showTimeSelector];
    }else if ([rowName isEqualToString:kRowRepeat]){
        [self goSelectWeekdayPage];
    }else if ([rowName isEqualToString:kRowMusic]){
        [self goSelectMusicPage];
    }else if ([rowName isEqualToString:kRowSnoozeTime]){
        [self showSnoozeTimeSelector];
    }else if ([rowName isEqualToString:kRowMusicVolumn]){
        [self showVolumeSelector];
    }
}

- (void)showVolumeSelector
{
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 1; i <= 16; i++) {
        [values addObject:@(i)];
    }
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:self.view mode:SLPMinutePickerMode_Second time:self.alarmDataNew.volume finishHandle:^(NSInteger timeValue) {
        weakSelf.alarmDataNew.volume = timeValue;
        [weakSelf.tableView reloadData];
    } cancelHandle:nil];
}

- (void)showTimeSelector
{
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = self.alarmDataNew.hour;
    time24.minute = self.alarmDataNew.minute;
    
    __weak typeof(self) weakSelf = self;
    TimePickerSelectView *timePick = [TimePickerSelectView timePickerSelectView];
    [timePick showInView:[UIApplication sharedApplication].keyWindow mode:![SLPUtils isTimeMode24] time:time24 finishHandle:^(SLPTime24 * _Nonnull time24) {
        weakSelf.alarmDataNew.hour = time24.hour;
        weakSelf.alarmDataNew.minute = time24.minute;
        [weakSelf.tableView reloadData];
    } cancelHandle:^{
        
    }];
}

- (void)goSelectWeekdayPage
{
    WeekdaySelectViewController *vc = [WeekdaySelectViewController new];
    vc.selectWeekDay = self.alarmDataNew.flag;
    
    __weak typeof(self) weakSelf = self;
    vc.weekdayBlock = ^(NSInteger weekday) {
        weakSelf.alarmDataNew.flag = weekday;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goSelectMusicPage
{
    if (self.alarmFooter.isPreviewEnabled) {
        [self stopPreView];
    }
    
    MusicListViewController *vc = [MusicListViewController new];
    vc.musicID = self.alarmDataNew.musicID;
    vc.musicList = self.musicList;
    vc.mode = FromMode_Alarm;
    __weak typeof(self) weakSelf = self;
    vc.musicBlock = ^(NSInteger musicID) {
        weakSelf.alarmDataNew.musicID = musicID;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)showSnoozeTimeSelector
{
    NSArray *values = @[@5,@10,@15];
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:self.view mode:SLPMinutePickerMode_Minute time:self.alarmDataNew.snoozeLength finishHandle:^(NSInteger timeValue) {
        weakSelf.alarmDataNew.snoozeLength = timeValue;
        [weakSelf.tableView reloadData];
    } cancelHandle:nil];
}

- (UITableViewCell *)getTableCellWithRowName:(NSString *)rowName
{
    BaseTableViewCell *cell = nil;
    
    __weak typeof(self) weakSelf = self;
    
    if ([rowName isEqualToString:kRowTime]) {
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"time");
        baseCell.subTitleLabel.text = [self getAlarmTimeStringWithDataModle:self.alarmDataNew];
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }else if ([rowName isEqualToString:kRowRepeat]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"reply");
        baseCell.subTitleLabel.text = [SLPWeekDay getAlarmRepeatDayStringWithWeekDay:self.alarmDataNew.flag];
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }else if ([rowName isEqualToString:kRowMusic]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"music");
        baseCell.subTitleLabel.text = [self getMusicNameWithMusicID:self.alarmDataNew.musicID];
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }else if([rowName isEqualToString:kRowMusicVolumn]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"volume");
        baseCell.subTitleLabel.text = [NSString stringWithFormat:@"%d", self.alarmDataNew.volume];
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }else if ([rowName isEqualToString:kRowLightWake]){
        TitleSwitchCell *sCell = (TitleSwitchCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSwitchCell"];
        sCell.titleLabel.text = LocalizedString(@"light_wake");
        sCell.switcher.on = self.alarmDataNew.brightness;
        [Utils configCellTitleLabel:sCell.titleLabel];
        sCell.switchBlock = ^(UISwitch *sender) {
            if (sender.on) {
                weakSelf.alarmDataNew.brightness = 100;
            }else{
                weakSelf.alarmDataNew.brightness = 0;
            }
        };
        cell = sCell;
    }

    else if ([rowName isEqualToString:kRowSnooze]){
        TitleSwitchCell *sCell = (TitleSwitchCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSwitchCell"];
        sCell.titleLabel.text = LocalizedString(@"snooze_");
        sCell.switcher.on = self.alarmDataNew.snoozeTime;
        [Utils configCellTitleLabel:sCell.titleLabel];
        
        
        sCell.switchBlock = ^(UISwitch *sender) {
            weakSelf.alarmDataNew.snoozeTime = sender.on;
            [weakSelf loadSectionData];
            [weakSelf.tableView reloadData];
        };
        cell = sCell;
    }else if ([rowName isEqualToString:kRowSnoozeTime]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = LocalizedString(@"snooze_duration");
        NSString *timeStr = [NSString stringWithFormat:@"%d%@", self.alarmDataNew.snoozeLength, LocalizedString(@"min")];
        baseCell.subTitleLabel.text = timeStr;
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }
    
    return cell;
}

- (NSString *)getMusicNameWithMusicID:(NSInteger)musicID
{
    NSString *musicName = @"";
    for (MusicInfo *musicInfo in self.musicList) {
        if (musicInfo.musicID == musicID) {
            musicName = musicInfo.musicName;
            break;
        }
    }
    
    return musicName;
}

- (NSString *)getAlarmTimeStringWithDataModle:(SLPAlarmInfo *)dataModel {
    return [SLPUtils timeStringFrom:dataModel.hour minute:dataModel.minute isTimeMode24:[SLPUtils isTimeMode24]];
}

- (IBAction)saveAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager alarmConfig:self.alarmDataNew deviceInfo:SharedDataManager.deviceID deviceType:SLPDeviceType_EW202W ip:@"" timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            [SharedDataManager.alarmList addObject:weakSelf.alarmDataNew];
            if ([self.delegate respondsToSelector:@selector(editAlarmInfoAndShouldReload)]) {
                [self.delegate editAlarmInfoAndShouldReload];
            }
            
            [Utils showMessage:LocalizedString(@"save_succeed") controller:weakSelf];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

-(void)previewBtnTapped:(BOOL)isSelected completion:(void (^)(BOOL))completion
{
    if (isSelected) {
        [self startPreView];
    }else{
        [self stopPreView];
    }
}

- (void)startPreView
{
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager ew202wAlarmRreviewOperationVolume:self.alarmDataNew.volume brightness:self.alarmDataNew.brightness operation:1 musicID:self.alarmDataNew.musicID deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            weakSelf.alarmFooter.isPreviewEnabled = YES;
        }
    }];
}

- (void)stopPreView
{
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager ew202wAlarmRreviewOperationVolume:self.alarmDataNew.volume brightness:self.alarmDataNew.brightness operation:0 musicID:self.alarmDataNew.musicID deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            weakSelf.alarmFooter.isPreviewEnabled = NO;
        }
    }];
}

-(void)deleteBtnTapped
{
    __weak typeof(self) weakSelf = self;
    self.alarmDataNew.enable = NO;
    [SLPSharedLTcpManager alarmConfig:self.alarmDataNew deviceInfo:SharedDataManager.deviceID deviceType:SLPDeviceType_EW202W ip:@"" timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            
            int index = 0;
            BOOL isExist = NO;
            for (int i = 0; i < SharedDataManager.alarmList.count; i++) {
                SLPAlarmInfo *info = [SharedDataManager.alarmList objectAtIndex:i];
                if (info.alarmID == self.alarmDataNew.alarmID) {
                    isExist = YES;
                    index = i;
                    break;
                }
            }
            
            if (isExist) {
                [SharedDataManager.alarmList removeObjectAtIndex:index];
            }
            
            if ([self.delegate respondsToSelector:@selector(editAlarmInfoAndShouldReload)]) {
                [self.delegate editAlarmInfoAndShouldReload];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)back
{
    [self stopPreView];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
