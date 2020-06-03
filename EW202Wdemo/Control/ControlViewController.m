//
//  ControlViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/13.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "ControlViewController.h"

#import "CustomStyleButton.h"
#import "ControlLightViewController.h"
#import "ControlAromaViewController.h"
#import "ControlSleepAidViewController.h"

#import <SLPTCP/SLPLTcpDef.h>

@interface ControlViewController ()

@property (weak, nonatomic) IBOutlet UIView *topBGView;

@property (weak, nonatomic) IBOutlet CustomStyleButton *lightBtn;
@property (weak, nonatomic) IBOutlet CustomStyleButton *sleepAidBtn;

@property (weak, nonatomic) IBOutlet UIView *firstSeperator;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) UIButton *currentBtn;

@property (nonatomic,strong) BaseViewController *selectedController;


@end

@implementation ControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self addNotificationObservre];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showConnected:SharedDataManager.connected];
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

- (void)setUI
{
    self.titleLabel.text = LocalizedString(@"control");
    
    self.topBGView.layer.masksToBounds = YES;
    self.topBGView.layer.borderColor = [Theme C2].CGColor;
    self.topBGView.layer.borderWidth = 1;
    self.topBGView.layer.cornerRadius = 5;
    self.firstSeperator.backgroundColor = [Theme C2];
    
    [self.lightBtn setTitle:LocalizedString(@"light") forState:UIControlStateNormal];
    [self.sleepAidBtn setTitle:LocalizedString(@"sleep_aid") forState:UIControlStateNormal];
    
    [[CustomStyleButton appearance] setNormalColor:[Theme C3]];
    [[CustomStyleButton appearance] setSelectedColor:[Theme C9]];
    
    [self.lightBtn setTitleColor:[Theme C3] forState:UIControlStateNormal];
    [self.sleepAidBtn setTitleColor:[Theme C3] forState:UIControlStateNormal];
    
    self.lightBtn.selected = YES;
    self.currentBtn = self.lightBtn;
    
    [self  showSectionViewControllerNamed:@"ControlLightViewController"];
    
}

- (void)showConnected:(BOOL)connected {
    CGFloat alpha = connected ? 1.0 : 0.3;
    [self.view setAlpha:alpha];
    
    [self.view setUserInteractionEnabled:connected];
}

- (void)showSectionViewControllerNamed:(NSString *)name{
    
    BaseViewController *sectionViewController = [NSClassFromString(name) new];
    
    if (!sectionViewController){
        return;
    }
    if (self.selectedController){
        [self.selectedController willMoveToParentViewController:nil];
        [self.selectedController.view removeFromSuperview];
        [self.selectedController removeFromParentViewController];
        self.selectedController=nil;
    }
    
    [sectionViewController willMoveToParentViewController:self];
    [self addChildViewController:sectionViewController];
    [SLPUtils addSubView:sectionViewController.view suitableTo:self.contentView];
    [self.contentView addSubview:sectionViewController.view];
    [sectionViewController didMoveToParentViewController:self];
    self.selectedController = sectionViewController;
}

- (IBAction)showLightPage:(UIButton *)sender {
    if (sender != self.currentBtn) {
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
        
        [self showLightPage];
    }
}

- (void)showLightPage
{
    [self showSectionViewControllerNamed:@"ControlLightViewController"];
}

- (IBAction)showSleepAidPage:(UIButton *)sender {
    if (sender != self.currentBtn) {
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
        
        [self showSleepAidPage];
    }
}

- (void)showSleepAidPage
{
    [self showSectionViewControllerNamed:@"ControlSleepAidViewController"];
}
@end

