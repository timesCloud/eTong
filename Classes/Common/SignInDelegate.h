//
//  SignInDelegate.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignInDelegate <NSObject>

@required
- (void)onLogin;
- (void)onUserHome;

@end
