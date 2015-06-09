//
//  TerminalStoreRegisterViewController.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStoreRegisterViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "UIView+XD.h"

@interface TerminalStoreRegisterViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation TerminalStoreRegisterViewController{
    UILabel *shopKeeperLabel;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"关联终端店"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    UIView *shopKeeperView = [ShareInstances addNormalItemViewOnView:self.view withY:_navigationBar.bottom+MARGIN_NARROW withTitle:@"管理人" canTouchUpInside:NO sender:nil action:nil];
    shopKeeperLabel = [ShareInstances addModifiableLabelOnView:shopKeeperView];

}

-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
