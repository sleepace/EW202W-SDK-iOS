//
//  Coordinate.m
//  Binatone-demo
//
//  Created by Martin on 28/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

+ (void)pushViewControllerName:(NSString *)name sender:(UIViewController *)sender animated:(BOOL)animated{
    UIViewController *viewController = [NSClassFromString(name) new];
    [sender.navigationController pushViewController:viewController animated:animated];
}
@end
