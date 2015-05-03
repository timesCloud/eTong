//
//  ResetPasswordViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/1.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "HyperlinksButton.h"
#import "Verifier.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "InputText.h"
#import "LoginViewController.h"

@interface ResetPasswordViewController()<NormalNavigationDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@property (nonatomic, weak) UITextField *verifyCodeText;
@property (nonatomic, weak) UILabel *verifyCodeTextName;
@property (nonatomic, weak) UITextField *passwordText;
@property (nonatomic, weak) UILabel *passwordTextName;
@property (nonatomic, weak) UIButton *signInBtn;
@property (nonatomic, assign) BOOL chang;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputRectangle];
}

- (void)setupInputRectangle
{
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"重置密码"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 100;
    UITextField *userText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.delegate = self;
    self.verifyCodeText = userText;
    [userText setKeyboardType:UIKeyboardTypeNumberPad];
    [userText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:userText];
    
    UILabel *userTextName = [self setupTextName:@"短信验证码" frame:userText.frame];
    self.verifyCodeTextName = userTextName;
    [self.view addSubview:userTextName];
    
    CGFloat passwordY = CGRectGetMaxY(userText.frame) + 30;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.passwordText = passwordText;
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"新密码" frame:passwordText.frame];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    UIButton *signInBtn = [[UIButton alloc] init];
    signInBtn.width = 200;
    signInBtn.height = 40;
    signInBtn.centerX = self.view.width * 0.5;
    signInBtn.y = CGRectGetMaxY(passwordText.frame) + 30;
    [signInBtn setTitle:@"立即重置" forState:UIControlStateNormal];
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
    if (textField == self.verifyCodeText) {
        [self diminishTextName:self.verifyCodeTextName];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.verifyCodeTextName textField:self.verifyCodeText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.verifyCodeText) {
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
    if ([_verifyCodeText.text isEqual:@""] || _verifyCodeText.text.length != 6) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"请输入正确的验证码"
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
        [SVProgressHUD showWithStatus:@"正在重置密码"];
        [AVUser resetPasswordWithSmsCode:_verifyCodeText.text newPassword:_passwordText.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD dismissWithSuccess:@"密码重置成功!" afterDelay:2];
                [((LoginViewController *)_homeViewController) setUserNameText:_phoneNo];
                [self.navigationController popToViewController:_homeViewController animated:YES];
            } else {
                [SVProgressHUD dismissWithError:@"密码重置失败" afterDelay:2];
            }
        }];
    }
}


@end
