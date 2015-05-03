//
//  SMSVerifyViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/31.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface SMSVerifyViewController : UIViewController

@property (nonatomic, weak) NSString *username;
@property (nonatomic, weak) NSString *password;

- (instancetype)initWithUsername:(NSString *)username withPassword:(NSString *)password;
- (void)regetVerifySMS:(NSString *)mobilePhoneNo;

@end
