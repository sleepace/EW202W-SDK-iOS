//
//  MainViewController.h
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainViewController : UIViewController

@end

@interface TabBarItem: NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *viewControllerClassString;

+ (TabBarItem *)tabBarItemWithTitle:(NSString *)title viewControllerClassString:(NSString *)viewControllerClassString;
@end
