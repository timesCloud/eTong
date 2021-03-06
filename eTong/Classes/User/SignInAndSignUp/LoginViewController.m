//
//  LoginViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "LoginViewController.h"
#import "InputText.h"
#import "UIView+XD.h"
#import "NormalNavigationBar.h"
#import "HyperlinksButton.h"
#import "Verifier.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "SignUpViewController.h"
#import "SMSVerifyViewController.h"
#import "Defines.h"
#import "InputPhoneNoViewController.h"
#import "CustomSettingViewController.h"
#import "RootViewController.h"
#import "ShareInstances.h"
#import "AccountInitViewController.h"

@interface LoginViewController()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) UITextField *userText;
@property (nonatomic, weak) UILabel *userTextName;
@property (nonatomic, weak) UITextField *passwordText;
@property (nonatomic, weak) UILabel *passwordTextName;
@property (nonatomic, weak) UIButton *signInBtn;
@property (nonatomic, weak) UILabel *signUpLabel;
@property (nonatomic, assign) BOOL chang;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputRectangle];
}

- (void)viewDidAppear:(BOOL)animated {//针对在短信验证界面成功登陆的情况
//    if ([AVUser currentUser] != nil) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [_rootViewController reloadSubViews];
//    }
}

- (void)setupInputRectangle
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *hdcLogoImage = [UIImage imageNamed:@"HDCLogo.jpg"];
    UIImageView *hdcLogoView = [[UIImageView alloc] initWithImage:hdcLogoImage];
    [hdcLogoView setFrame:CGRectMake(0, 20, self.view.width, hdcLogoImage.size.height * (self.view.width / hdcLogoImage.size.width))];
    [self.view addSubview:hdcLogoView];
    
    UIView *welcomeView = [[UIView alloc] initWithFrame:CGRectMake(0, hdcLogoView.bottom + 20, self.view.width, 44)];
    [ShareInstances addTopBottomBorderOnView:welcomeView];
    [welcomeView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    UILabel *welcomeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, welcomeView.width, 16)];
    [welcomeLable setFont:[UIFont systemFontOfSize:16]];
    [welcomeLable setTextColor:NORMAL_TEXT_COLOR];
    [welcomeLable setTextAlignment:NSTextAlignmentCenter];
    [welcomeLable setText:@"欢迎使用壹通，请先登录或注册"];
    [welcomeView addSubview:welcomeLable];
    [self.view addSubview:welcomeView];
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = welcomeView.bottom + 30;
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
    [signInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [signInBtn setBackgroundColor:MAIN_COLOR];
    self.signInBtn = signInBtn;
    [signInBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    
    HyperlinksButton *retrievePasswordButton = [[HyperlinksButton alloc] init];
    retrievePasswordButton.width = 120;
    retrievePasswordButton.height = 44;
    retrievePasswordButton.centerX = self.view.width * 0.25;
    retrievePasswordButton.y = CGRectGetMaxY(signInBtn.frame) + 20;
    [retrievePasswordButton setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
    [retrievePasswordButton setTitleColor:LINK_TEXT_COLOR forState:UIControlStateNormal];
    [retrievePasswordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [retrievePasswordButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [retrievePasswordButton setUnderLineColor:LINK_TEXT_COLOR];
    [retrievePasswordButton addTarget:self action:@selector(doRetrievePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retrievePasswordButton];
    
    HyperlinksButton *signUpButton = [[HyperlinksButton alloc] init];
    signUpButton.width = 120;
    signUpButton.height = 44;
    signUpButton.centerX = self.view.width * 0.75;
    signUpButton.y = CGRectGetMaxY(signInBtn.frame) + 20;
    [signUpButton setTitle:@"新用户注册" forState:UIControlStateNormal];
    [signUpButton setTitleColor:LINK_TEXT_COLOR forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [signUpButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [signUpButton setUnderLineColor:LINK_TEXT_COLOR];
    [signUpButton addTarget:self action:@selector(doSignUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    UIView *existingAccountInitView = [[UIView alloc] initWithFrame:CGRectMake(0, signUpButton.bottom + 40, self.view.width, 44)];
    [ShareInstances addTopBottomBorderOnView:existingAccountInitView];
    [existingAccountInitView setBackgroundColor:[UIColor whiteColor]];
    UILabel *existingAccountInitLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, existingAccountInitView.width - 20 - 44, 14)];
    [existingAccountInitLable setFont:[UIFont systemFontOfSize:14]];
    [existingAccountInitLable setTextColor:NORMAL_TEXT_COLOR];
    [existingAccountInitLable setTextAlignment:NSTextAlignmentCenter];
    [existingAccountInitLable setText:@"品牌商、经销商首次登陆入口"];
    [existingAccountInitView addSubview:existingAccountInitLable];
    UIImageView *goImageView = [[UIImageView alloc] initWithFrame:CGRectMake(existingAccountInitView.width - 44, 0, 44, existingAccountInitView.height)];
    [goImageView setImage:[UIImage imageNamed:@"go_normal.png"]];
    [goImageView setContentMode:UIViewContentModeCenter];
    [existingAccountInitView addSubview:goImageView];
    [self.view addSubview:existingAccountInitView];
    UITapGestureRecognizer *accountInitTGP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doAccountInit)];
    [existingAccountInitView addGestureRecognizer:accountInitTGP];
    
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

#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self restoreTextName:self.userTextName textField:self.userText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
}

- (void)loginBtnClick
{
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
        [self AVOSSignIn:self.userText.text password:self.passwordText.text];
    }
}

- (void)AVOSSignIn:(NSString *)username password:(NSString *)password {
    [SVProgressHUD showWithStatus:@"正在登陆"];
    [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [SVProgressHUD dismissWithSuccess:@"登陆成功"];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
            
//            if (![self userSettingIsCompletion]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完善个人资料" message:@"您的个人资料尚有未完善之处，为了让跑跑更好的为您服务，请再恩赐一点点时间吧" delegate:self cancelButtonTitle:@"下次吧" otherButtonTitles:@"立即完善", nil];
//                [alertView show];
//            } else{
                //[self dismissViewControllerAnimated:YES completion:^{
                    //[_rootViewController reloadSubViews];
                //}];
//            }
        } else {
            NSInteger errorCode = error.code;
            if (errorCode == 215) {
                [SVProgressHUD dismissWithError:@"您尚未验证手机，现在进行验证" afterDelay:2];
                SMSVerifyViewController *SMSVerifyVC = [[SMSVerifyViewController alloc] init];
                [SMSVerifyVC regetVerifySMS:username];
                [self.navigationController pushViewController:SMSVerifyVC animated:YES];
            } else if (errorCode == 210){
                [SVProgressHUD dismissWithError:@"手机号或密码错误，登陆失败" afterDelay:2];
            } else {
                [SVProgressHUD dismissWithError:@"登陆失败" afterDelay:2];
            }
        }
    }];
}

- (BOOL)userSettingIsCompletion{
    AVUser *user = [AVUser currentUser];
    BOOL completion = ([user objectForKey:@"sex"] != nil);
    completion = completion && ([user objectForKey:@"industry"] != nil);
    completion = completion && ([user objectForKey:@"signature"] != nil);
    completion = completion  && ([user objectForKey:@"nickname"] != nil);
    completion = completion  && ([user objectForKey:@"birthday"] != nil);
    completion = completion  && ([user objectForKey:@"headPortrait"] != nil);
    completion = completion  && ([user relationforKey:@"favoriteSport"] != nil);
    return completion;
}

-(void)doRetrievePassword {
    InputPhoneNoViewController *inputPhoneNoVC = [[InputPhoneNoViewController alloc] init];
    inputPhoneNoVC.homeViewController = self;
    [self.navigationController pushViewController:inputPhoneNoVC animated:YES];
}

-(void)doSignUp {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

-(void)doAccountInit {
    AccountInitViewController *accountInitVC = [[AccountInitViewController alloc] init];
    [self.navigationController pushViewController:accountInitVC animated:YES];
}

- (void)setUserNameText:(NSString *)userName{
    _userText.text = userName;
    [self textFieldShouldBeginEditing:_userText];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        CustomSettingViewController *customSettingVC = [[CustomSettingViewController alloc] init];
        customSettingVC.settingMode = 999;
        [self.navigationController pushViewController:customSettingVC animated:YES];
    } else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
