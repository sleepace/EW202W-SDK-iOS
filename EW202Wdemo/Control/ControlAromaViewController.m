//
//  ControlAromaViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/15.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "ControlAromaViewController.h"


#import "CustomColorButton.h"

@interface ControlAromaViewController ()

@property (weak, nonatomic) IBOutlet CustomColorButton *fastBtn;

@property (weak, nonatomic) IBOutlet CustomColorButton *midBtn;

@property (weak, nonatomic) IBOutlet CustomColorButton *slowBtn;

@property (weak, nonatomic) IBOutlet UIButton *openAroma;

@property (nonatomic, weak) UIButton *currentBtn;


@end

@implementation ControlAromaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI
{
    [self.fastBtn setTitle:LocalizedString(@"fast") forState:UIControlStateNormal];
    [self.midBtn setTitle:LocalizedString(@"middle") forState:UIControlStateNormal];
    [self.slowBtn setTitle:LocalizedString(@"slow") forState:UIControlStateNormal];
    [self.openAroma setTitle:LocalizedString(@"close_aroma") forState:UIControlStateNormal];
    
    [[CustomColorButton appearance] setNormalColor:[Theme C2]];
    [[CustomColorButton appearance] setSelectedColor:[Theme C9]];
    
    [self.fastBtn setTitleColor:[Theme C2] forState:UIControlStateNormal];
    [self.midBtn setTitleColor:[Theme C2] forState:UIControlStateNormal];
    [self.slowBtn setTitleColor:[Theme C2] forState:UIControlStateNormal];
    [self.openAroma setTitleColor:[Theme C9] forState:UIControlStateNormal];
    self.openAroma.backgroundColor = [Theme C2];
    
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
}

- (IBAction)fastAction:(UIButton *)sender {
    if (self.currentBtn != sender) {
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
        
        [self setAromaRateWith:3];
    }
}

- (IBAction)midAction:(UIButton *)sender {
    if (self.currentBtn != sender) {
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
        
        [self setAromaRateWith:2];
    }
}

- (IBAction)slowAction:(UIButton *)sender {
    if (self.currentBtn != sender) {
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
        
        [self setAromaRateWith:1];
    }
}

- (IBAction)openAromaAction:(UIButton *)sender {
    [self setAromaRateWith:0];
    
    self.currentBtn.selected = NO;
    self.currentBtn = nil;
}

- (void)setAromaRateWith:(UInt8)rate
{
    
}
@end
