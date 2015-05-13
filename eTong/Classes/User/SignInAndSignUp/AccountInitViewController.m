//
//  SignUpiewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/31.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "AccountInitViewController.h"
#import "InputText.h"
#import "UIView+XD.h"
#import "NormalNavigationBar.h"
#import "HyperlinksButton.h"
#import "Verifier.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "SMSVerifyViewController.h"
#import "Defines.h"

@interface AccountInitViewController()<UITextFieldDelegate, NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@property (nonatomic, weak) UITextField *userText;
@property (nonatomic, weak) UILabel *userTextName;
@property (nonatomic, weak) UITextField *passwordText;
@property (nonatomic, weak) UILabel *passwordTextName;
@property (nonatomic, weak) UIButton *signInBtn;
@property (nonatomic, assign) BOOL chang;

@end

@implementation AccountInitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputRectangle];
}

- (void)setupInputRectangle
{
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"账户初始化"];
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
    
    UILabel *userTextName = [self setupTextName:@"手机号码" frame:userText.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    
    CGFloat passwordY = CGRectGetMaxY(userText.frame) + 30;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.passwordText = passwordText;
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"密码" frame:passwordText.frame];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    UIButton *signInBtn = [[UIButton alloc] init];
    signInBtn.width = 200;
    signInBtn.height = 40;
    signInBtn.centerX = self.view.width * 0.5;
    signInBtn.y = CGRectGetMaxY(passwordText.frame) + 30;
    [signInBtn setTitle:@"验证手机号码" forState:UIControlStateNormal];
    [signInBtn setBackgroundColor:MAIN_COLOR];
    self.signInBtn = signInBtn;
    [signInBtn addTarget:self action:@selector(signUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
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
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userText) {
        return [self.passwordText becomeFirstResponder];
    } else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        return [self.passwordText resignFirstResponder];
    }
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

- (void)signUpBtnClick {
    if (![Verifier isMobileNumber:_userText.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"手机号码格式有误"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        
        [alert show];
    } else if ([_passwordText.text isEqual: @""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"密码不能为空"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        
        [alert show];
    } else {
        [self AVOSSignUp:self.userText.text withPassword:self.passwordText.text];
    }
}

- (void)AVOSSignUp:(NSString *)telNo withPassword:(NSString *)password {
    [SVProgressHUD showWithStatus:@"正在尝试登陆"];
    [AVUser logInWithUsernameInBackground:telNo password:@"TimesCloud" block:^(AVUser *user, NSError *error) {
        if (!error) {//账户已做过手机号码验证，且直接使用缺省密码登陆成功
            [SVProgressHUD dismissWithSuccess:@"您已进行过初始化，已成功登陆" afterDelay:2];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
        } else {//直接缺省密码登陆失败
            NSInteger errorCode = error.code;
            switch (errorCode) {
                case 210:{//手机号码已验证，所以尝试使用新输入密码登陆
                    [AVUser logInWithUsernameInBackground:telNo password:password block:^(AVUser *user, NSError *error) {
                        if (!error) {//新密码登陆成功
                            [SVProgressHUD dismissWithSuccess:@"您已进行过初始化，已成功登陆" afterDelay:2];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
                        } else {//登陆失败
                            [SVProgressHUD dismissWithSuccess:@"您之前已进行过初始化并修改密码，请返回登陆，若忘记密码请使用找回密码功能" afterDelay:3];
                            [self.navigationController popViewControllerAnimated:YES];
                            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
                        }
                    }];
                    break;
                }
                case 215:{//手机号码未验证，请求验证
                    [SVProgressHUD showWithStatus:@"正在获取短信验证码"];
                    [AVUser requestMobilePhoneVerify:telNo withBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [SVProgressHUD dismissWithSuccess:@"获取成功，请稍候" afterDelay:2];
                            SMSVerifyViewController *smsVerifyVC = [[SMSVerifyViewController alloc] initWithUsername:telNo withPassword:password];
                            smsVerifyVC.username = telNo;
                            smsVerifyVC.password = password;
                            smsVerifyVC.mode = 1;
                            [self.navigationController pushViewController:smsVerifyVC animated:YES];
                        } else {
                            [SVProgressHUD dismissWithError:@"获取失败" afterDelay:2];
                        }
                    }];

                    break;
                }
                case 211:{
                    [SVProgressHUD dismissWithError:@"对应账户不存在，请确认后重试" afterDelay:3];
                    break;
                }
                default:
                    [SVProgressHUD dismissWithError:@"未知故障，登陆失败" afterDelay:2];
                    break;
            }
        }
    }];
}

@end
