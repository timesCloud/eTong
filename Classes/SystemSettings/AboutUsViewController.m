//
//  AboutUsViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/27.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIView+XD.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "ShareInstances.h"

#define lCopyRightTextSize 12
#define lProtocolTextSize 13
#define lMargin 10
#define lTableViewCellHeight 44

@interface AboutUsViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"关于我们"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom + lMargin * 2, self.view.width, 80)];
    imageView.contentMode = UIViewContentModeCenter;
    [imageView setImage:[UIImage imageNamed:@"logoRev.png"]];
    [self.view addSubview:imageView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + lMargin, self.view.width, 18)];
    [versionLabel setFont:[UIFont systemFontOfSize:18]];
    [versionLabel setTextColor:LIGHT_TEXT_COLOR];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setText:@"当前版本：1.0.1"];
    [self.view addSubview:versionLabel];
    
    UIView *tableBGView = [[UIView alloc] initWithFrame:CGRectMake(0, versionLabel.bottom + lMargin * 2, self.view.width, lTableViewCellHeight * 4)];
    [ShareInstances addTopBottomBorderOnView:tableBGView];
    [self.view addSubview:tableBGView];
    
    UILabel *copyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bottom - lCopyRightTextSize - lMargin, self.view.width, lCopyRightTextSize)];
    [copyRightLabel setFont:[UIFont systemFontOfSize:lCopyRightTextSize]];
    [copyRightLabel setTextColor:LIGHT_TEXT_COLOR];
    [copyRightLabel setTextAlignment:NSTextAlignmentCenter];
    [copyRightLabel setText:@"成都时代智云科技有限公司 版权所有"];
    [self.view addSubview:copyRightLabel];
    
    UILabel *protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, copyRightLabel.y - lProtocolTextSize - lMargin, self.view.width, lProtocolTextSize + 2)];
    [protocolLabel setFont:[UIFont systemFontOfSize:lProtocolTextSize]];
    [protocolLabel setTextColor:LINK_TEXT_COLOR];
    [protocolLabel setTextAlignment:NSTextAlignmentCenter];
    [protocolLabel setText:@"查看Running跑跑软件许可及服务协议"];
    [self.view addSubview:protocolLabel];
}

- (void)doReturn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
