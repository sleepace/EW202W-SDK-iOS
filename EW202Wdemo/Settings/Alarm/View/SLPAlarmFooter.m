//
//  SLPAlarmFooter.m
//  Sleepace
//
//  Created by Shawley on 8/1/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPAlarmFooter.h"

static const NSInteger kOffsetEdge = 15;
static const NSInteger kOffsetUp = 40;

@interface SLPAlarmFooter ()
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *previewTopEdge;
@end

@implementation SLPAlarmFooter

+ (instancetype)footerViewWithTextStr:(NSString *)textStr {
    SLPAlarmFooter *footer = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    [SLPUtils setLableNormalAttributes:footer.label text:textStr font:[Theme T4]];
    
    [footer resetPreviewTopEge];
    return footer;
}

- (CGFloat)footerLabelHeight {
    CGFloat fontSize = 14;
    NSString *textStr = self.label.text?:@"";
    //字符串为空的时候
    if (self.label.text.length == 0) {
        return 10.0;
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    NSRange rang = NSMakeRange(0, textStr.length);
    [attributedStr addAttributes:[self getAttributesWithFontSize:fontSize] range:rang];
    [self.label setAttributedText:attributedStr];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - 2 * kOffsetEdge;
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:options attributes:[self getAttributesWithFontSize:fontSize] context:nil].size;
    return ceil(size.height) + kOffsetUp;
}

- (void)resetPreviewTopEge {
    CGFloat topEdge = 30.0;
    if (self.label.text.length == 0){
        topEdge = 10.0;
    }
    self.previewTopEdge.constant = topEdge;
}

- (NSDictionary *)getAttributesWithFontSize:(CGFloat)fontSize {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.minimumLineHeight = fontSize + 7;
    paragraphStyle.maximumLineHeight = paragraphStyle.minimumLineHeight;
    paragraphStyle.hyphenationFactor = 0.97;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[Theme T4],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 };
    return attributes;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.font = [Theme T4];
    self.label.textColor = [Theme C4];
//    [SLPUtils configSomeKindOfButtonLikeRegister:self.previewBtn];
    [self.previewBtn setTitle:LocalizedString(@"preview_alarm") forState:UIControlStateNormal];
    [self.previewBtn setTitleColor:[Theme C9] forState:UIControlStateNormal];
    [self.previewBtn.titleLabel setFont:[Theme T1]];
    self.previewBtn.backgroundColor = [Theme C2];
    
    self.previewBtn.layer.masksToBounds = YES;
    self.previewBtn.layer.cornerRadius = 5;
    
    [self.deleteBtn setTitle:LocalizedString(@"delete_alram") forState:UIControlStateNormal];
    [self.deleteBtn.titleLabel setFont:[Theme T1]];
    [self.deleteBtn setTitleColor:[Theme C7] forState:UIControlStateNormal];
}

- (void)setIsPreviewEnabled:(BOOL)isPreviewEnabled {
    _isPreviewEnabled = isPreviewEnabled;
    [self refreshPreviewBtnTitle:isPreviewEnabled];
}

- (IBAction)previewButtonTapped:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewBtnTapped:completion:)]) {
        __weak typeof(self) weakSelf = self;
        [self.delegate previewBtnTapped:!self.isPreviewEnabled completion:^(BOOL result) {
            if (result) {
                weakSelf.isPreviewEnabled = !weakSelf.isPreviewEnabled;
                [weakSelf refreshPreviewBtnTitle:weakSelf.isPreviewEnabled];
            } else {
//                weakSelf.isPreviewEnabled = !weakSelf.isPreviewEnabled;
            }
        }];
    }
}

- (IBAction)deleteButtonTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnTapped)]) {
        [self.delegate deleteBtnTapped];
    }
}

- (void)refreshPreviewBtnTitle:(BOOL)isEnabled {
    if (isEnabled) {
        [self.previewBtn setTitle:LocalizedString(@"preview_stop") forState:UIControlStateNormal];
    } else {
        [self.previewBtn setTitle:LocalizedString(@"preview_alarm") forState:UIControlStateNormal];
    }
}

- (CGFloat)height {
    CGFloat height = self.footerLabelHeight;
    if (self.deleteBtn.hidden) {
        height += 90;
    }else{
        height += 150;
    }
    return height;
}
@end
