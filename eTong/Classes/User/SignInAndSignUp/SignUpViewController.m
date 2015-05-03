//
//  SignUpiewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/31.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SignUpViewController.h"
#import "InputText.h"
#import "UIView+XD.h"
#import "NormalNavigationBar.h"
#import "HyperlinksButton.h"
#import "Verifier.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "SMSVerifyViewController.h"
#import "Defines.h"

@interface SignUpViewController()<UITextFieldDelegate, NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@property (nonatomic, weak) UITextField *userText;
@property (nonatomic, weak) UILabel *userTextName;
@property (nonatomic, weak) UITextField *passwordText;
@property (nonatomic, weak) UILabel *passwordTextName;
@property (nonatomic, weak) UIButton *signInBtn;
@property (nonatomic, assign) BOOL chang;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputRectangle];
}

- (void)setupInputRectangle
{
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"新用户注册"];
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
    [signInBtn setTitle:@"立即注册" forState:UIControlStateNormal];
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
    //注册AVOSCloud
    AVUser *user = [AVUser user];
    user.username = telNo;
    user.password =  password;
    user.mobilePhoneNumber = telNo;
    [user setObject:[NSString stringWithFormat:@"跑跑用户%@", [telNo substringFromIndex:7]] forKey:@"nickname"];
    [SVProgressHUD showWithStatus:@"正在注册"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD dismissWithSuccess:@"注册成功，进行短信验证" afterDelay:2];
            [AVUser logOut];
            SMSVerifyViewController *smsVerifyVC = [[SMSVerifyViewController alloc] initWithUsername:telNo withPassword:password];
            [self.navigationController pushViewController:smsVerifyVC animated:YES];
            
        } else {
            NSInteger errorCode = error.code;
            NSString *errorString;
            if (errorCode == 214)
                errorString = [NSString stringWithFormat:@"该手机号已经注册过"];
            else if (errorCode == -1009)
                errorString = [NSString stringWithFormat:@"网络故障，注册失败"];
            else
                errorString = [NSString stringWithFormat:@"未知故障，注册失败"];
            [SVProgressHUD dismissWithError:errorString afterDelay:2];
        }
    }];
//    if([user signUp]) {
////        SmsVerificationViewController *smsVerificationVC = [[SmsVerificationViewController alloc] init];
////        smsVerificationVC.user = user;
////        [self.navigationController pushViewController:smsVerificationVC animated:YES];
//    }else {
////        TTAlertNoTitle(@"该手机号已存在，不能重复注册！");
////        [self hideHud];
//    }
}

@end
