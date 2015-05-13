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

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic) NSInteger mode;//mode为1表示为初始化模式，需要将缺省密码修改为新密码

- (instancetype)initWithUsername:(NSString *)username withPassword:(NSString *)password;
- (void)regetVerifySMS:(NSString *)mobilePhoneNo;

@end
