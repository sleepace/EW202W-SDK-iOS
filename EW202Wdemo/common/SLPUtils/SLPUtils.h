//
//  SLPUtils.h
//  Profession
//
//  Created by Martin on 4/6/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

@interface SLPUtils : NSObject

+ (UITableViewCell *)tableView:(UITableView *)tableView cellNibName:(NSString *)nibName;

+ (void)setLableNormalAttributes:(UILabel *)label text:(NSString *)text font:(UIFont *)font;

+ (CGFloat)stringHeightWithConstraintedWidth:(CGFloat)width text:(NSString *)text font:(UIFont *)font;

+ (void)addSubView:(UIView *)subView suitableTo:(UIView *)superView;

@end
