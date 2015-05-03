//
//  ModifyPasswordViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "HyperlinksButton.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "InputText.h"

@interface ModifyPasswordViewController()<NormalNavigationDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@property (nonatomic, weak) UITextField *curPasswordText;
@property (nonatomic, weak) UILabel *curPasswordTextName;
@property (nonatomic, weak) UITextField *passwordText;
@property (nonatomic, weak) UILabel *passwordTextName;
@property (nonatomic, weak) UIButton *signInBtn;
@property (nonatomic, assign) BOOL chang;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputRectangle];
}

- (void)setupInputRectangle
{
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"修改密码"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 100;
    UITextField *curPasswordText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    curPasswordText.delegate = self;
    self.curPasswordText = curPasswordText;
    [curPasswordText setReturnKeyType:UIReturnKeyNext];
    [curPasswordText setSecureTextEntry:YES];
    [self.view addSubview:curPasswordText];
    
    UILabel *userTextName = [self setupTextName:@"现在的密码" frame:curPasswordText.frame];
    self.curPasswordTextName = userTextName;
    [self.view addSubview:userTextName];
    
    CGFloat passwordY = CGRectGetMaxY(curPasswordText.frame) + 30;
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
    [signInBtn setTitle:@"立即修改" forState:UIControlStateNormal];
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
    if (textField == self.curPasswordText) {
        [self diminishTextName:self.curPasswordTextName];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.curPasswordTextName textField:self.curPasswordText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.curPasswordText) {
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
    NSString *warning = @"";
    if ([_curPasswordText.text isEqual:@""]) {
        warning = @"现在的密码不能为空";
    } else if ([_passwordText.text isEqual: @""]){
        warning = @"新密码不能为空";
    } else if (_passwordText.text.length < 8) {
        warning = @"新密码不能少于8个字符";
    }
    
    if ([warning isEqualToString:@""]) {
        [SVProgressHUD showWithStatus:@"正在修改密码"];
        [[AVUser currentUser] updatePassword:_curPasswordText.text newPassword:_passwordText.text block:^(id object, NSError *error) {
            if (!error) {
                [SVProgressHUD dismissWithSuccess:@"密码修改成功!" afterDelay:2];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                NSInteger errorCode = error.code;
                if (errorCode == 210) {
                    [SVProgressHUD dismissWithError:@"现密码输入错误，密码修改失败" afterDelay:2];
                }else{
                    [SVProgressHUD dismissWithError:@"密码修改失败" afterDelay:2];
                }
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:warning
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        
        [alert show];
    }
}


@end
