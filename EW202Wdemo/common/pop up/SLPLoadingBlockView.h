//
//  SLPLoadingBlockView.h
//  Sleepace
//
//  Created by Martin on 2017/5/23.
//  Copyright © 2017年 com.medica. All rights reserved.
//

#import "SLPPopBaseView.h"

@interface SLPLoadingBlockView : SLPPopBaseView

+ (SLPLoadingBlockView *)showInViewController:(UIViewController *)viewController
                                      topEdge:(CGFloat)topEdge animated:(BOOL)animated;

- (void)setText:(NSString *)text;
@end
