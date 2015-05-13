//
//  LoginViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface LoginViewController : UIViewController

@property (nonatomic, weak) RootViewController *rootViewController;

- (void)setUserNameText:(NSString *)userName;

@end
