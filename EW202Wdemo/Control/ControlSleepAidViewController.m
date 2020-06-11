//
//  ControlSleepAidViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/15.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "ControlSleepAidViewController.h"


#import "MusicListViewController.h"
#import "MusicInfo.h"
#import "SLPMinuteSelectView.h"
#import "CustomColorButton.h"

@interface ControlSleepAidViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

// 第一段
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon1;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UILabel *volLabel;
@property (weak, nonatomic) IBOutlet UITextField *volTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopMusicBtn;
@property (weak, nonatomic) IBOutlet UIView *line3;


// 第二段
@property (weak, nonatomic) IBOutlet UITextField *colorRTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorGTextfFiled;
@property (weak, nonatomic) IBOutlet UITextField *colorBTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *colorWTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *brightnessTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *sendColorBtn;

@property (weak, nonatomic) IBOutlet UIButton *sendBrightnessBtn;

@property (weak, nonatomic) IBOutlet UIButton *openLightBtn;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (weak, nonatomic) IBOutlet UIView *line4;

// 第三段
@property (weak, nonatomic) IBOutlet UILabel *aromaLabel;

@property (weak, nonatomic) IBOutlet CustomColorButton *fastBtn;

@property (weak, nonatomic) IBOutlet CustomColorButton *midBtn;

@property (weak, nonatomic) IBOutlet CustomColorButton *slowBtn;

@property (weak, nonatomic) IBOutlet CustomColorButton *openAroma;

@property (nonatomic, weak) UIButton *currentAromaBtn;

@property (weak, nonatomic) IBOutlet UIView *line5;
@property (weak, nonatomic) IBOutlet UIView *line6;

@property (weak, nonatomic) IBOutlet UILabel *aromeTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon2;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) NSMutableArray *musicList;

@property (nonatomic, assign) BOOL isPlayingMusic;
@property (nonatomic, assign) CGFloat offset;

@end

@implementation ControlSleepAidViewController

-(NSMutableArray *)musicList{
    if (!_musicList) {
        _musicList = [NSMutableArray array];
        
        MusicInfo *musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31086;
        musicInfo.musicName = LocalizedString(@"music_list_You");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31087;
        musicInfo.musicName = LocalizedString(@"music_list_Moon");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31088;
        musicInfo.musicName = LocalizedString(@"music_list_Here");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31089;
        musicInfo.musicName = LocalizedString(@"music_list_Journey");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31090;
        musicInfo.musicName = LocalizedString(@"music_list_World");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31091;
        musicInfo.musicName = LocalizedString(@"music_list_Baby");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31092;
        musicInfo.musicName = LocalizedString(@"music_list_Lullaby");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31093;
        musicInfo.musicName = LocalizedString(@"music_list_star");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31094;
        musicInfo.musicName = LocalizedString(@"music_list_sun");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31095;
        musicInfo.musicName = LocalizedString(@"music_list_sea");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31096;
        musicInfo.musicName = LocalizedString(@"music_list_rain");
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31097;
        musicInfo.musicName = LocalizedString(@"music_list_dance");
        [_musicList addObject:musicInfo];
    }
    
    return _musicList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotifications];
//    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.colorGTextfFiled.text = @"0";
    self.brightnessTextFiled.text = @"30";
    self.volTextField.text = @"10";
    
    [self setUI];
    
    [self getAidInfo];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//-(void)textFiledEditChanged:(NSNotification*)obj {
//    UITextField *textField = (UITextField *)obj.object;
//    NSString *toBeString = textField.text;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if(toBeString.length > 3) {
//                textField.text = [toBeString substringToIndex:3];
//            }
//
//        }
//        //有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//
//        }
//    }
//    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况：emoji表情、en-US
//    else{
//        if (toBeString.length > 3) {
//            textField.text= [toBeString substringToIndex:3];
//        }
//    }
//
//}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.offset = self.scroll.bounds.origin.y;
    //1. 获取键盘的 Y 值
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.scroll setContentOffset:CGPointMake(0, self.offset + keyboardFrame.size.height)];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.scroll setContentOffset:CGPointMake(0, self.offset)];
}

- (void)setUI
{
    self.line1.backgroundColor = [Theme normalLineColor];
    self.line2.backgroundColor = [Theme normalLineColor];
    self.line3.backgroundColor = [Theme normalLineColor];
    self.line4.backgroundColor = [Theme normalLineColor];
    self.line5.backgroundColor = [Theme normalLineColor];
    self.line6.backgroundColor = [Theme normalLineColor];
    
    self.arrowIcon1.image = [UIImage imageNamed:@"common_list_icon_leftarrow"];
    self.arrowIcon2.image = [UIImage imageNamed:@"common_list_icon_leftarrow"];
    
    [self setMusicUI];
    
    [self setLightUI];
    
    [self setAromaUI];
}

- (void)setMusicUI
{
    self.musicLabel.text = LocalizedString(@"music");
    self.volLabel.text = LocalizedString(@"volume");
    self.musicLabel.textColor = Theme.C4;
    self.volLabel.textColor = Theme.C4;
    
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5;
    [self.sendBtn setTitle:LocalizedString(@"send") forState:UIControlStateNormal];
    self.stopMusicBtn.layer.masksToBounds = YES;
    self.stopMusicBtn.layer.cornerRadius = 5;
    
    if (SharedDataManager.aidInfo.volume > 0) {
        self.volTextField.text = [NSString stringWithFormat:@"%d", SharedDataManager.aidInfo.volume];
    }
}

- (void)setLightUI
{
    self.colorRTextField.text = [NSString stringWithFormat:@"%d", 255];
    self.colorBTextFiled.text = [NSString stringWithFormat:@"%d", 0];
    self.colorWTextFiled.text = [NSString stringWithFormat:@"%d", 0];
    
    self.colorLabel.text = LocalizedString(@"color");
    self.brightnessLabel.text = LocalizedString(@"luminance");
    self.colorLabel.textColor = Theme.C4;
    self.brightnessLabel.textColor = Theme.C4;
    
    [self.sendColorBtn setTitle:LocalizedString(@"send") forState:UIControlStateNormal];
    [self.sendBrightnessBtn setTitle:LocalizedString(@"send") forState:UIControlStateNormal];
    [self.openLightBtn setTitle:LocalizedString(@"turn_off") forState:UIControlStateNormal];
    
    self.sendColorBtn.backgroundColor = [Theme C2];
    self.sendBrightnessBtn.backgroundColor = [Theme C2];
    self.openLightBtn.backgroundColor = [Theme C2];
    
    self.sendColorBtn.layer.masksToBounds = YES;
    self.sendColorBtn.layer.cornerRadius = 5;
    self.sendBrightnessBtn.layer.masksToBounds = YES;
    self.sendBrightnessBtn.layer.cornerRadius = 5;
    self.openLightBtn.layer.masksToBounds = YES;
    self.openLightBtn.layer.cornerRadius = 5;
    
    self.musicNameLabel.text = [self getMusicNameWithMusicID:SharedDataManager.aidInfo.musicID];
    
    [self.stopMusicBtn setTitle:LocalizedString(@"play") forState:UIControlStateNormal];
    
    if (SharedDataManager.aidInfo.g > 0) {
        self.colorGTextfFiled.text = [NSString stringWithFormat:@"%d", SharedDataManager.aidInfo.g];
    }
    
    if (SharedDataManager.aidInfo.brightness > 0) {
        self.brightnessTextFiled.text = [NSString stringWithFormat:@"%d", SharedDataManager.aidInfo.brightness];
    }
}

- (void)setAromaUI
{
    self.aromaLabel.text = LocalizedString(@"aroma");
    self.aromaLabel.textColor = Theme.C4;
    
    [self.fastBtn setTitle:LocalizedString(@"fast") forState:UIControlStateNormal];
    [self.midBtn setTitle:LocalizedString(@"middle") forState:UIControlStateNormal];
    [self.slowBtn setTitle:LocalizedString(@"slow") forState:UIControlStateNormal];
    [self.openAroma setTitle:LocalizedString(@"close") forState:UIControlStateNormal];
    
    [[CustomColorButton appearance] setNormalColor:[Theme C2]];
    [[CustomColorButton appearance] setSelectedColor:[Theme C9]];
    
    [self.fastBtn setTitleColor:[Theme C2] forState:UIControlStateNormal];
    [self.midBtn setTitleColor:[Theme C2] forState:UIControlStateNormal];
    [self.slowBtn setTitleColor:[Theme C2] forState:UIControlStateNormal];
    [self.openAroma setTitleColor:[Theme C2] forState:UIControlStateNormal];
    
    self.fastBtn.layer.masksToBounds = YES;
    self.fastBtn.layer.cornerRadius = 5;
    self.fastBtn.layer.borderColor = [Theme C2].CGColor;
    self.fastBtn.layer.borderWidth = 1;
    self.midBtn.layer.masksToBounds = YES;
    self.midBtn.layer.cornerRadius = 5;
    self.midBtn.layer.borderColor = [Theme C2].CGColor;
    self.midBtn.layer.borderWidth = 1;
    self.slowBtn.layer.masksToBounds = YES;
    self.slowBtn.layer.cornerRadius = 5;
    self.slowBtn.layer.borderColor = [Theme C2].CGColor;
    self.slowBtn.layer.borderWidth = 1;
    self.openAroma.layer.masksToBounds = YES;
    self.openAroma.layer.cornerRadius = 5;
    self.openAroma.layer.borderColor = [Theme C2].CGColor;
    self.openAroma.layer.borderWidth = 1;
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d%@", SharedDataManager.aidInfo.aidStopDuration, LocalizedString(@"min")];
    NSString *duration = [NSString stringWithFormat:@"%d", SharedDataManager.aidInfo.aidStopDuration];
    self.descLabel.text = [NSString stringWithFormat:LocalizedString(@"music_aroma_light_close2"), duration];
    self.descLabel.textColor = Theme.C4;
    self.timeLabel.textColor = Theme.C4;
    
    self.aromeTimeLabel.text = LocalizedString(@"time_out");
    
    [self.saveBtn setTitle:LocalizedString(@"save") forState:UIControlStateNormal];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 5;
}

- (void)getAidInfo
{
    __weak typeof(self) weakSelf = self;

    [SLPSharedLTcpManager ew202wGetAidInfoWithDeviceInfo:SharedDataManager.deviceID  timeOut:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SLPAidInfo *info = data;
            SharedDataManager.aidInfo = info;
            
            [weakSelf setUI];
        }
    }];
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

- (IBAction)sendVolAction:(UIButton *)sender {
    if (!self.volTextField.text.length) {
        [Utils showMessage:LocalizedString(@"input_0_16") controller:self];
        return;
    }
    
    NSInteger volume = [self.volTextField.text integerValue];
    if (volume < 1 || volume > 16) {
        [Utils showMessage:LocalizedString(@"input_0_16") controller:self];
        return;
    }
    
    UInt8 vol = volume;
    
    __weak typeof(self) weakSelf = self;
    SLPAidInfo *aidInfo = [self localAidInfo];
    aidInfo.volume = vol;
    [SLPSharedLTcpManager ew202wConfigAidInfo:aidInfo deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            SharedDataManager.aidInfo.volume = vol;
        }
    }];
}

- (IBAction)playMusic:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    
    if (!self.volTextField.text.length) {
        [Utils showMessage:LocalizedString(@"input_0_16") controller:self];
        return;
    }
    
    NSInteger volume = [self.volTextField.text integerValue];
    if (volume < 1 || volume > 16) {
        [Utils showMessage:LocalizedString(@"input_0_16") controller:self];
        return;
    }
    
    if (sender.selected) {
        
        [self stopMusicWitCompletion:^(SLPDataTransferStatus status) {
            if (status != SLPDataTransferStatus_Succeed) {
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }else{
                SharedDataManager.aidInfo.musicFlag = 0;
                sender.selected = NO;
                [weakSelf.stopMusicBtn setTitle:LocalizedString(@"play") forState:UIControlStateNormal];
                weakSelf.isPlayingMusic = NO;
            }
        }];
    }else{
        [self playMusicWitCompletion:^(SLPDataTransferStatus status) {
            if (status != SLPDataTransferStatus_Succeed) {
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }else{
                SharedDataManager.aidInfo.musicFlag = 1;
                sender.selected = YES;
                [weakSelf.stopMusicBtn setTitle:LocalizedString(@"pause") forState:UIControlStateNormal];
                weakSelf.isPlayingMusic = YES;
            }
        }];
    }
}

- (void)playMusicWitCompletion:(void(^)(SLPDataTransferStatus status))completion
{
    SLPAidInfo *aidInfo = [self localAidInfo];
    aidInfo.musicFlag = 1;
    [SLPSharedLTcpManager ew202wConfigAidInfo:aidInfo deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
         if (completion) {
             completion(status);
        }
    }];
}

- (void)stopMusicWitCompletion:(void(^)(SLPDataTransferStatus status))completion
{
    SLPAidInfo *aidInfo = [self localAidInfo];
    aidInfo.musicFlag = 0;
    [SLPSharedLTcpManager ew202wConfigAidInfo:aidInfo deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
         if (completion) {
             completion(status);
        }
    }];
}

- (IBAction)sendColorAction:(UIButton *)sender {
    if (!self.colorGTextfFiled.text.length) {
        [Utils showMessage:LocalizedString(@"input_0_120") controller:self];
        return;
    }
    
    int g = [self.colorGTextfFiled.text intValue];
    BOOL gValid = (g >= 0) && (g <= 120);
    if (!gValid) {
        [Utils showMessage:LocalizedString(@"input_0_120") controller:self];
        return;
    }
    [self turnOnLight];
}

- (void)turnOnLight
{
    
    int r = [self.colorRTextField.text intValue];
    int g = [self.colorGTextfFiled.text intValue];
    int b = [self.colorBTextFiled.text intValue];
    int w = [self.colorWTextFiled.text intValue];
    
    int brightness = [self.brightnessTextFiled.text intValue];
    
    if (!self.brightnessTextFiled.text.length) {
        brightness = 50;
    }
    BOOL brightValid = (brightness >= 0) && (brightness <= 100);
    if (!brightValid) {
        brightness = 50;
    }

    __weak typeof(self) weakSelf = self;
    
    SLPAidInfo *aidInfo = [self localAidInfo];
    aidInfo.lightFlag = 1;
    aidInfo.r = r;
    aidInfo.g = g;
    aidInfo.b = b;
    aidInfo.w = w;
    aidInfo.brightness = brightness;
    
    [SLPSharedLTcpManager ew202wConfigAidInfo:aidInfo deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            SharedDataManager.aidInfo = aidInfo;
        }else{
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

- (IBAction)sendBrightnessAction:(UIButton *)sender {
    if (!self.brightnessTextFiled.text.length) {
        [Utils showMessage:LocalizedString(@"input_0_100") controller:self];
        return;
    }
    
    int brightness = [self.brightnessTextFiled.text intValue];
    BOOL brightValid = (brightness >= 0) && (brightness <= 100);
    if (!brightValid) {
        [Utils showMessage:LocalizedString(@"input_0_100") controller:self];
        return;
    }
    [self turnOnLight];
}

- (IBAction)openLightAction:(UIButton *)sender {
    SLPAidInfo *aidInfo = [[SLPAidInfo alloc] init];
    aidInfo.lightFlag = 0;
    
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager ew202wConfigAidInfo:aidInfo deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }
    }];
}

- (IBAction)goMusicList:(id)sender {
    MusicListViewController *vc = [MusicListViewController new];
    vc.musicList = self.musicList;
    vc.musicID = SharedDataManager.aidInfo.musicID;
    vc.mode = FromMode_SleepAid;
    __weak typeof(self) weakSelf = self;
    vc.musicBlock = ^(NSInteger musicID) {
        SharedDataManager.aidInfo.musicID = musicID;
        weakSelf.musicNameLabel.text = [weakSelf getMusicNameWithMusicID:musicID];
        
        if (weakSelf.isPlayingMusic) {
            [weakSelf playMusicWitCompletion:nil];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectTime:(id)sender {
    [self showTimeSelector];
}

- (IBAction)saveAction:(id)sender {
    [self saveAssistInfo];
}

- (void)saveAssistInfo
{
    int r = [self.colorRTextField.text intValue];
    int g = [self.colorGTextfFiled.text intValue];
    int b = [self.colorRTextField.text intValue];
    int w = [self.colorWTextFiled.text intValue];
    
    BOOL gValid = (g >= 0) && (g <= 120);
    
    if (!gValid) {
        [Utils showMessage:LocalizedString(@"input_0_120") controller:self];
        return;
    }
    
    int brightness = [self.brightnessTextFiled.text intValue];
    BOOL brightValid = (brightness >= 0) && (brightness <= 100);
    if (!brightValid) {
        [Utils showMessage:LocalizedString(@"input_0_100") controller:self];
        return;
    }
    
    NSInteger volumn = [self.volTextField.text integerValue];
    if (volumn < 1 || volumn > 16) {
        [Utils showMessage:LocalizedString(@"input_0_16") controller:self];
        return;
    }
    
    SLPAidInfo *aidInfo = [self currentAidInfo];
    
    __weak typeof(self) weakSelf = self;
    [SLPSharedLTcpManager ew202wConfigAidInfo:aidInfo deviceInfo:SharedDataManager.deviceID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            SharedDataManager.aidInfo = aidInfo;
            NSLog(@"brightness %d",SharedDataManager.aidInfo.brightness);
            [Utils showMessage:LocalizedString(@"save_succeed") controller:weakSelf];
        }
    }];
}

- (void)showTimeSelector
{
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        [values addObject:@(i)];
    }
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:[UIApplication sharedApplication].keyWindow mode:SLPMinutePickerMode_Minute time:SharedDataManager.aidInfo.aidStopDuration finishHandle:^(NSInteger timeValue) {
        SharedDataManager.aidInfo.aidStopDuration = timeValue;
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%ld%@", timeValue, LocalizedString(@"min")];
        NSString *duration = [NSString stringWithFormat:@"%ld", timeValue];
        weakSelf.descLabel.text = [NSString stringWithFormat:LocalizedString(@"music_aroma_light_close"), duration];
    } cancelHandle:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];//结束编辑状态，即可以关闭键盘
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}

-(SLPAidInfo *)localAidInfo
{
    SLPAidInfo *info = [SLPAidInfo new];
    
    info.musicFlag = SharedDataManager.aidInfo.musicFlag;
    info.musicID = SharedDataManager.aidInfo.musicID;
    info.volume = SharedDataManager.aidInfo.volume;
    info.musicMode = SharedDataManager.aidInfo.musicMode;
    info.lightFlag = SharedDataManager.aidInfo.lightFlag;
    info.brightness = SharedDataManager.aidInfo.brightness;
    info.r = SharedDataManager.aidInfo.r;
    info.g = SharedDataManager.aidInfo.g;
    info.b = SharedDataManager.aidInfo.b;
    info.w = SharedDataManager.aidInfo.w;
    info.aidStopDuration = SharedDataManager.aidInfo.aidStopDuration;
    
    return info;
}

-(SLPAidInfo *)currentAidInfo
{
    SLPAidInfo *info = [SLPAidInfo new];
    
    info.musicFlag = self.stopMusicBtn.selected;
    info.musicID = SharedDataManager.aidInfo.musicID;
    info.volume = [self.volTextField.text integerValue];
    info.musicMode = SharedDataManager.aidInfo.musicMode;
    info.lightFlag = SharedDataManager.aidInfo.lightFlag;
    info.brightness = [self.brightnessTextFiled.text intValue];
    info.r = SharedDataManager.aidInfo.r;
    info.g = [self.colorGTextfFiled.text intValue];
    info.b = SharedDataManager.aidInfo.b;
    info.w = SharedDataManager.aidInfo.w;
    info.aidStopDuration = SharedDataManager.aidInfo.aidStopDuration;

    return info;
}

@end
