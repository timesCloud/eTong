//
//  InputPhoneNoViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/1.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "InputPhoneNoViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "HyperlinksButton.h"
#import "Verifier.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "InputText.h"
#import "ResetPasswordViewController.h"

@interface InputPhoneNoViewController()<NormalNavigationDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, weak) UITextField *userText;
@property (nonatomic, weak) UILabel *userTextName;
@property (nonatomic, weak) UIButton *signInBtn;
@property (nonatomic, assign) BOOL chang;

@end

@implementation InputPhoneNoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];

    [self setupInputRectangle];
}

- (void)setupInputRectangle
{
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"找回密码"];
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
    
    UILabel *userTextName = [self setupTextName:@"请输入注册所用手机号码" frame:userText.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    
    UIButton *signInBtn = [[UIButton alloc] init];
    signInBtn.width = 200;
    signInBtn.height = 40;
    signInBtn.centerX = self.view.width * 0.5;
    signInBtn.y = CGRectGetMaxY(userTextName.frame) + 30;
    [signInBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
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
    [self diminishTextName:self.userTextName];
    return YES;
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (textField == self.userText) {
//        return [self.passwordText becomeFirstResponder];
//    } else {
//        [self restoreTextName:self.passwordTextName textField:self.passwordText];
//        return [self.passwordText resignFirstResponder];
//    }
//}
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

- (void)signUpBtnClick {
    if (![Verifier isMobileNumber:_userText.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"手机号码格式有误"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        
        [alert show];
    } else {
        [SVProgressHUD showWithStatus:@"获取短信验证码"];
        [AVUser requestPasswordResetWithPhoneNumber:_userText.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD dismissWithSuccess:@"获取成功" afterDelay:2];
                ResetPasswordViewController *resetVC = [[ResetPasswordViewController alloc] init];
                resetVC.homeViewController = self.homeViewController;
                resetVC.phoneNo = _userText.text;
                [self.navigationController pushViewController:resetVC animated:YES];
            } else {
                [SVProgressHUD dismissWithError:@"获取失败" afterDelay:2];
            }
        }];
    }
}

#pragma mark NormalNavigationDelegate
- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
