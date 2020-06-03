//
//  SLPUtils.m
//  Profession
//
//  Created by Martin on 4/6/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPUtils.h"

@implementation SLPUtils

+ (UITableViewCell *)tableView:(UITableView *)tableView cellNibName:(NSString *)nibName{
    if (!tableView || [nibName length] == 0){
        return nil;
    }
    
    NSString *cellID = nibName;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}

+ (void)setLableNormalAttributes:(UILabel *)label text:(NSString *)text font:(UIFont *)font {
    if (!label || !text) {
        return;
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange rang = NSMakeRange(0, text.length);
    [attributedStr addAttributes:[self attributesWithFont:font] range:rang];
    [label setAttributedText:attributedStr];
}

+ (NSDictionary *)attributesWithFont:(UIFont *)font {
    if (!font) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.minimumLineHeight = font.pointSize + 6;
    paragraphStyle.maximumLineHeight = paragraphStyle.minimumLineHeight;
    paragraphStyle.hyphenationFactor = 0.97;
    NSDictionary *attributes = @{ NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle};
    return attributes;
}

+ (CGFloat)stringHeightWithConstraintedWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font {
    if (!text) {
        return 0;
    }
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize boundingBox = [text boundingRectWithSize:constraint options:options attributes:[self attributesWithFont:font] context:nil].size;
    return ceil(boundingBox.height);
}

+ (void)addSubView:(UIView *)subView suitableTo:(UIView *)superView{
    if (!subView || !superView){
        return;
    }
    
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [superView addSubview:subView];
    NSDictionary *subViews = NSDictionaryOfVariableBindings(subView,superView);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:subViews]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:subViews]];
}
@end
