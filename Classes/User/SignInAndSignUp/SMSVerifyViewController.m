//
//  SMSVerifyViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/31.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SMSVerifyViewController.h"
#import "InputText.h"
#import "UIView+XD.h"
#import "NormalNavigationBar.h"
#import "HyperlinksButton.h"
#import "Verifier.h"
#import "SVProgressHUD.h"
#import "Defines.h"

@interface SMSVerifyViewController()<UITextFieldDelegate, NormalNavigationDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@property (nonatomic, weak) UITextField *userText;
@property (nonatomic, weak) UILabel *userTextName;
@property (nonatomic, weak) UIButton *signInBtn;
@property (nonatomic, weak) UIButton *getSMSBtn;
@property (nonatomic, assign) BOOL chang;

@end

@implementation SMSVerifyViewController {
    NSInteger _timeTicks;
    NSTimer *_timer;
    NSDate *_timerBeginTime;
}

- (instancetype)initWithUsername:(NSString *)username withPassword:(NSString *)password {
    self = [super init];
    _username = username;
    _password = password;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputRectangle];
    [self initRegetSMSCountDown];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onAppResignActive:) name:KNOTIFICATION_APPRESIGNACTIVE object:nil];
}

- (void)onAppResignActive:(NSNotification *)notification {
    if ([_timer isValid]) {
        NSDate *now = [NSDate date];
        NSTimeInterval timeInterval = [now timeIntervalSinceDate:_timerBeginTime];
        if (timeInterval < 120) {
            _timeTicks = 120 - timeInterval;
            [self refreshRegetSMSCountDown];
        } else {
            [self disableRegetSMSCountDown];
        }
    }
}

- (void)initRegetSMSCountDown {
    _timeTicks = 120;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerTime:) userInfo:nil repeats:YES];
    _timerBeginTime = [NSDate date];
    [_getSMSBtn setBackgroundColor:[UIColor grayColor]];
}

- (void)disableRegetSMSCountDown {
    [_getSMSBtn setTitle:@"重新获取短信" forState:UIControlStateNormal];
    [_getSMSBtn setBackgroundColor:MAIN_COLOR];
    [_timer invalidate];
}

- (void)refreshRegetSMSCountDown {
    [_getSMSBtn setTitle:[NSString stringWithFormat:@"%ld秒后可重新获取短信", (long)_timeTicks] forState:UIControlStateNormal];
}

- (void)setupInputRectangle
{
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"短信验证"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 100;
    UITextField *userText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.delegate = self;
    self.userText = userText;
    [userText setKeyboardType:UIKeyboardTypeNumberPad];
    [userText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:userText];
    
    UILabel *userTextName = [self setupTextName:@"短信验证码" frame:userText.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    
    UIButton *signInBtn = [[UIButton alloc] init];
    signInBtn.width = 200;
    signInBtn.height = 40;
    signInBtn.centerX = self.view.width * 0.5;
    signInBtn.y = CGRectGetMaxY(userText.frame) + 30;
    [signInBtn setTitle:@"确定" forState:UIControlStateNormal];
    [signInBtn setBackgroundColor:[UIColor orangeColor]];
    self.signInBtn = signInBtn;
    [signInBtn addTarget:self action:@selector(signUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    
    UIButton *getSMSBtn = [[UIButton alloc] init];
    getSMSBtn.width = 200;
    getSMSBtn.height = 40;
    getSMSBtn.centerX = self.view.width * 0.5;
    getSMSBtn.y = CGRectGetMaxY(signInBtn.frame) + 30;
    [getSMSBtn setTitle:@"重新获取短信" forState:UIControlStateNormal];
    [getSMSBtn setBackgroundColor:[UIColor orangeColor]];
    self.getSMSBtn = getSMSBtn;
    [getSMSBtn addTarget:self action:@selector(getSMSBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getSMSBtn];
}

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
    }
    return YES;
}

- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:9];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)regetVerifySMS:(NSString *)mobilePhoneNo {
    [_getSMSBtn setBackgroundColor:[UIColor grayColor]];
    [AVUser requestMobilePhoneVerify:mobilePhoneNo withBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取验证短信失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            [self initRegetSMSCountDown];
        }
    }];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    [self disableRegetSMSCountDown];
}

- (void)VerifyMobilePhoneNo:(NSString *)mobilePhoneNo {
    [SVProgressHUD showWithStatus:@"正在验证"];
    [AVUser verifyMobilePhone:mobilePhoneNo withBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [SVProgressHUD dismissWithSuccess:@"验证成功，正在登陆" afterDelay:2];
            [AVUser logInWithUsernameInBackground:_username password:_password block:^(AVUser *user, NSError *error) {
                if (!error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"登录失败，请稍后重试" duration:2];
                }
            }];
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"验证码错误或已过期，验证失败:%ld", (long)error.code] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)onTimerTime:(NSTimer *)timer {
    [self refreshRegetSMSCountDown];
    if (--_timeTicks <= 0)
        [self disableRegetSMSCountDown];
}

- (void)signUpBtnClick {
    if ([_userText.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"请输入正确的短信验证码"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        
        [alert show];
    } else {
        [self VerifyMobilePhoneNo:_userText.text];
    }
}

- (void)getSMSBtnClick {
    if (![_timer isValid])
        [self regetVerifySMS:_username];
}


@end
