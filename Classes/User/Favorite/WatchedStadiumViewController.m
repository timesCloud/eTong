//
//  WatchedStadiumViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "WatchedStadiumViewController.h"
#import "WatchedStadiumTableViewDND.h"
#import "CustomTableView.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"

@interface WatchedStadiumViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation WatchedStadiumViewController{
    WatchedStadiumTableViewDND *watchedStadiumDND;
    CustomTableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = NORMAL_BACKGROUND_COLOR;
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"场馆收藏"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    if (tableView == nil){
        tableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, self.view.width, self.view.height - _navigationBar.bottom)];
    }
    if(watchedStadiumDND == nil)
        watchedStadiumDND = [[WatchedStadiumTableViewDND alloc] init];
    tableView.delegate = watchedStadiumDND;
    tableView.dataSource = watchedStadiumDND;
    [self.view addSubview:tableView];
    
    [tableView forceToFreshData];
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
