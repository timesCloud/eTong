//
//  AppDelegate.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/2.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RootViewController *viewController;

@property (strong, nonatomic) UINavigationController *navgationController;


@end

