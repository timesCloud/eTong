//
//  UserHomeViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/2.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "UserHomeViewController.h"
#import "UIView+XD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Defines.h"
#import "SVProgressHUD.h"
#import "UIView+XD.h"
#import "ShareInstances.h"
#import "ImgShowViewController.h"
#import "VPImageCropperViewController.h"


#import "MyOrderViewController.h"
#import "CustomSettingViewController.h"
#import "WatchedStadiumViewController.h"
#import "DynamicWaveView.h"
#import "CustomSettingViewController.h"
#import "ModifyPasswordViewController.h"

#define lMargin 10
#define lNormalTextSize 13.0f

@interface UserHomeViewController()<CustomSettingViewDelegate>

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *signatureLabel;
@property (nonatomic, strong) UIView *nicknameAndSexView;

@end

@implementation UserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = NORMAL_BACKGROUND_COLOR;
    
    DynamicWaveView *accountView = [[DynamicWaveView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 224)];
    accountView.backgroundColor = MAIN_COLOR;
    [self.view addSubview:accountView];
    //导航返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, NAVIGATION_BUTTON_RESPONSE_WIDTH, NAVIGATION_BUTTON_HEIGHT)];
    [backButton setImage:[UIImage imageNamed:@"back_round.png"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, NAVIGATION_LBUTTON_MARGIN_LEFT, 0, NAVIGATION_BUTTON_RESPONSE_WIDTH-NAVIGATION_LBUTTON_MARGIN_LEFT-NAVIGATION_BUTTON_WIDTH)];
    [backButton addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [accountView addSubview:backButton];
    
    //编辑个人信息按钮
    UIButton *userInfoEditButton = [[UIButton alloc] initWithFrame:CGRectMake(accountView.width - NAVIGATION_BUTTON_RESPONSE_WIDTH, STATU_BAR_HEIGHT, NAVIGATION_BUTTON_RESPONSE_WIDTH, NAVIGATION_BUTTON_HEIGHT)];
    [userInfoEditButton setImage:[UIImage imageNamed:@"edit_round.png"] forState:UIControlStateNormal];
    [userInfoEditButton setImageEdgeInsets:UIEdgeInsetsMake(0, NAVIGATION_LBUTTON_MARGIN_LEFT, 0, NAVIGATION_BUTTON_RESPONSE_WIDTH-NAVIGATION_LBUTTON_MARGIN_LEFT-NAVIGATION_BUTTON_WIDTH)];
    [userInfoEditButton addTarget:self action:@selector(doEditUserInfo) forControlEvents:UIControlEventTouchUpInside];
    //[userInfoEditButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [userInfoEditButton setImageEdgeInsets:UIEdgeInsetsMake(0, userInfoEditButton.width - NAVIGATION_BUTTON_HEIGHT, 0, 5)];
    [accountView addSubview:userInfoEditButton];
    //头像图片视图
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake((accountView.width - 72) / 2, 35, 72, 72)];
    [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
    [_portraitImageView.layer setMasksToBounds:YES];
    [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_portraitImageView setClipsToBounds:YES];
    _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
    _portraitImageView.layer.shadowOpacity = 0.5;
    _portraitImageView.layer.shadowRadius = 2.0;
    _portraitImageView.userInteractionEnabled = YES;
    _portraitImageView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCurUserFullHeadPortrait)];
    [_portraitImageView addGestureRecognizer:portraitTap];
    [accountView addSubview:_portraitImageView];
    //昵称标签和性别视图
    _nicknameAndSexView = [[UIView alloc] initWithFrame:CGRectMake(0, _portraitImageView.bottom + lMargin, 0, 17)];
    [_nicknameAndSexView setBackgroundColor:[UIColor clearColor]];
    [accountView addSubview:_nicknameAndSexView];
    //昵称标签
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 17)];
    [_nicknameLabel setFont:[UIFont systemFontOfSize:17]];
    [_nicknameLabel setTextColor:[UIColor whiteColor]];
    [_nicknameAndSexView addSubview:_nicknameLabel];
    //性别图片视图
    _sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_nicknameLabel.right + lMargin, 3, _nicknameAndSexView.height - 6, _nicknameAndSexView.height - 6)];
    [_sexImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_nicknameAndSexView addSubview:_sexImageView];
    //年龄标签
    _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sexImageView.right + 5, 2, 15, 13)];
    [_ageLabel setFont:[UIFont systemFontOfSize:13]];
    [_ageLabel setTextColor:[UIColor whiteColor]];
    //签名标签
    _signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(lMargin, _nicknameAndSexView.bottom + lMargin, accountView.width - lMargin * 2, 12)];
    [_signatureLabel setFont:[UIFont systemFontOfSize:12]];
    [_signatureLabel setTextColor:LIGHT_BACKGROUND_COLOR];
    [_signatureLabel setTextAlignment:NSTextAlignmentCenter];
    [accountView addSubview:_signatureLabel];
    
    [ShareInstances addRightArrowOnView:accountView];
    
    //重要操作视图，在用户信息视图正下方
    UIView *importantOperView = [[UIView alloc] initWithFrame:CGRectMake(0, accountView.bottom, self.view.width, 60)];
    [importantOperView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:importantOperView];
    
    //我的场次
    UIView *mySessionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, importantOperView.width / 3 - 0.5, importantOperView.height)];
    UIImageView *calendarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lMargin, mySessionView.width, 24)];
    [calendarImageView setImage:[UIImage imageNamed:@"calendar.png"]];
    [calendarImageView setContentMode:UIViewContentModeCenter];
    [mySessionView addSubview:calendarImageView];
    UILabel *mySessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, calendarImageView.bottom + 5, mySessionView.width, lNormalTextSize)];
    [mySessionLabel setFont:[UIFont systemFontOfSize:lNormalTextSize]];
    [mySessionLabel setTextColor:NORMAL_TEXT_COLOR];
    [mySessionLabel setTextAlignment:NSTextAlignmentCenter];
    [mySessionLabel setText:@"我的场次"];
    [mySessionView addSubview:mySessionLabel];
    [mySessionView setHeight:mySessionLabel.bottom + lMargin];
    [importantOperView setHeight:mySessionView.height];
    UITapGestureRecognizer *mySessionTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SettingsOnTouch)];
    [mySessionView addGestureRecognizer:mySessionTapGR];
    
    UIView *splitterView1 = [[UIView alloc] initWithFrame:CGRectMake(mySessionView.right, 5, 0.5, importantOperView.height - 10)];
    [splitterView1 setBackgroundColor:SPLITTER_COLOR];
    
    //我的关注
    UIView *myFavoriteView = [[UIView alloc] initWithFrame:CGRectMake(splitterView1.right, 0, importantOperView.width / 3, importantOperView.height)];
    [importantOperView addSubview:myFavoriteView];
    UIImageView *fevoriteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lMargin, myFavoriteView.width, 24)];
    [fevoriteImageView setImage:[UIImage imageNamed:@"favorite.png"]];
    [fevoriteImageView setContentMode:UIViewContentModeCenter];
    [myFavoriteView addSubview:fevoriteImageView];
    UILabel *myFavoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fevoriteImageView.bottom + 5, myFavoriteView.width, lNormalTextSize)];
    [myFavoriteLabel setFont:[UIFont systemFontOfSize:lNormalTextSize]];
    [myFavoriteLabel setTextColor:NORMAL_TEXT_COLOR];
    [myFavoriteLabel setTextAlignment:NSTextAlignmentCenter];
    [myFavoriteLabel setText:@"我的收藏"];
    [myFavoriteView addSubview:myFavoriteLabel];
    UITapGestureRecognizer *myFavoriteTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFavoriteOnTouch)];
    [myFavoriteView addGestureRecognizer:myFavoriteTapGR];
    
    UIView *splitterView2 = [[UIView alloc] initWithFrame:CGRectMake(myFavoriteView.right, 5, 0.5, importantOperView.height - 10)];
    [splitterView2 setBackgroundColor:SPLITTER_COLOR];
    
    //我的订单
    UIView *myOrderView = [[UIView alloc] initWithFrame:CGRectMake(splitterView2.right, 0, importantOperView.width - splitterView2.right, importantOperView.height)];
    UIImageView *orderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lMargin, myOrderView.width, 24)];
    [orderImageView setImage:[UIImage imageNamed:@"shoppingBag.png"]];
    [orderImageView setContentMode:UIViewContentModeCenter];
    [myOrderView addSubview:orderImageView];
    UILabel *myOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, orderImageView.bottom + 5, myOrderView.width, lNormalTextSize)];
    [myOrderLabel setFont:[UIFont systemFontOfSize:lNormalTextSize]];
    [myOrderLabel setTextColor:NORMAL_TEXT_COLOR];
    [myOrderLabel setTextAlignment:NSTextAlignmentCenter];
    [myOrderLabel setText:@"我的订单"];
    [myOrderView addSubview:myOrderLabel];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myOrderOnTouch)];
    [myOrderView addGestureRecognizer:tapGR];
    
    [importantOperView addSubview:mySessionView];
    [importantOperView addSubview:splitterView1];
    [importantOperView addSubview:myFavoriteView];
    [importantOperView addSubview:splitterView2];
    [importantOperView addSubview:myOrderView];
    
    [ShareInstances addTopBottomBorderOnView:importantOperView];
    
    UIView *modifyPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, importantOperView.bottom + lMargin, self.view.width, 44)];
    [modifyPasswordView setBackgroundColor:[UIColor whiteColor]];
    [ShareInstances addTopBottomBorderOnView:modifyPasswordView];
    [self.view addSubview:modifyPasswordView];
    
    UITapGestureRecognizer *modifyTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doModifyPassword)];
    [modifyPasswordView addGestureRecognizer:modifyTapGR];
    
    UILabel *modifyPasswordLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 120, 16)];
    [modifyPasswordLable setFont:[UIFont systemFontOfSize:16]];
    [modifyPasswordLable setText:@"修改密码"];
    [modifyPasswordLable setTextAlignment:NSTextAlignmentLeft];
    [modifyPasswordLable setTextColor:NORMAL_TEXT_COLOR];
    [modifyPasswordView addSubview:modifyPasswordLable];
    
    UIImageView *modifyPasswordIV = [[UIImageView alloc] initWithFrame:CGRectMake(modifyPasswordView.width - 44, 0, 44, modifyPasswordView.height)];
    [modifyPasswordIV setImage:[UIImage imageNamed:@"go_normal.png"]];
    [modifyPasswordIV setContentMode:UIViewContentModeCenter];
    [modifyPasswordView addSubview:modifyPasswordIV];
    
    UIButton *LogOutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, modifyPasswordView.bottom + lMargin, self.view.width, 44)];
    [LogOutButton setBackgroundColor:DARK_BACKGROUND_COLOR];
    [LogOutButton setTitle:@"登出账户" forState:UIControlStateNormal];
    [LogOutButton setTitleColor:NORMAL_TEXT_COLOR forState:UIControlStateNormal];
    [LogOutButton addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
    [ShareInstances addTopBottomBorderOnView:LogOutButton];
    [self.view addSubview:LogOutButton];
    
    [self setAccountInfo];
}

- (void)setAccountInfo{
    [ShareInstances loadPortraitOnView:_portraitImageView withDefaultImageName:DEFAULT_PORTRAIT forceReload:YES];
    AVUser *curUser = [AVUser currentUser];
    NSString *nickname = [curUser objectForKey:@"nickname"];
    [_nicknameLabel setWidth:17 * [nickname length]];
    [_nicknameLabel setText:nickname];
    NSInteger sex = [(NSNumber *)[curUser objectForKey:@"sex"] integerValue];
    switch (sex) {
        case 1://男
            [_sexImageView setImage:[UIImage imageNamed:@"male.png"]];
            break;
        case 2://女
            [_sexImageView setImage:[UIImage imageNamed:@"female.png"]];
        default:
            break;
    }
    [_sexImageView setX:_nicknameLabel.right + lMargin];
    NSDate *birthday = [curUser objectForKey:@"birthday"];
    NSInteger age = [[NSDate date] timeIntervalSinceDate:birthday] / (3600 * 24 * 365.25);
    [_ageLabel setText:[NSString stringWithFormat:@"%ld", age]];
    [_ageLabel setX:_sexImageView.right + 5];
    [_nicknameAndSexView addSubview:_ageLabel];
    [_nicknameAndSexView setWidth:_ageLabel.right];
    [_nicknameAndSexView setX:(self.view.width - _nicknameAndSexView.width) / 2];

    [_signatureLabel setText:[curUser objectForKey:@"signature"]];
}

- (void)doModifyPassword{
    ModifyPasswordViewController *modifyPassword = [[ModifyPasswordViewController alloc] init];
    [self.navigationController pushViewController:modifyPassword animated:YES];
}

- (void)doLogout:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"已退出当前账户" duration:2];
    [AVUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doEditUserInfo{
    CustomSettingViewController *customeSettingVC = [[CustomSettingViewController alloc] init];
    customeSettingVC.delegate = self;
    [self.navigationController pushViewController:customeSettingVC animated:YES];
}

- (void)userSettingChanged{
    [self setAccountInfo];
}

//点击“我的收藏”
- (void)myFavoriteOnTouch {
    WatchedStadiumViewController *watchedStadiumVC = [[WatchedStadiumViewController alloc] init];
    [self.navigationController pushViewController:watchedStadiumVC animated:YES];
}

//点击“我的订单”
- (void)myOrderOnTouch {
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

//点击“关于我们”
- (void)SettingsOnTouch {
    CustomSettingViewController *aboutUsVC = [[CustomSettingViewController alloc] init];
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}

//显示头像大图
- (void)showCurUserFullHeadPortrait {
    AVUser *curUser = [AVUser currentUser];
    AVFile *imageFile = [curUser objectForKey:@"headPortrait"];
    NSMutableArray *images = [NSMutableArray arrayWithObject:imageFile];
    ImgShowViewController *imageShowVC = [[ImgShowViewController alloc] initWithSourceData:images withIndex:0];
    [self.navigationController pushViewController:imageShowVC animated:YES];
}


@end
