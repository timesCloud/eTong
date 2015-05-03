//
//  MyOrderViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/14.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "MyOrderViewController.h"
#import "NormalNavigationBar.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "MenuHrizontal.h"
#import "CustomTableView.h"
#import "CanceledOrderTableViewDND.h"

#define MENUHEIHT 40

@interface MyOrderViewController() <NormalNavigationDelegate, MenuHrizontalDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation MyOrderViewController {
    MenuHrizontal *mMenuHriZontal;
    NSMutableArray *tableViewArray;
    CanceledOrderTableViewDND *canceledDND;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = NORMAL_BACKGROUND_COLOR;
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"我的订单"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    NSArray *vButtonItemArray = @[@{NOMALKEY: @"subTabbar_normal.png",
                                    HEIGHTKEY:@"subTabbar_highLight.png",
                                    TITLEKEY:@"未付款",
                                    TITLEWIDTH:[NSNumber numberWithFloat:self.view.width / 3]
                                    },
                                  @{NOMALKEY: @"subTabbar_normal.png",
                                    HEIGHTKEY:@"subTabbar_highLight.png",
                                    TITLEKEY:@"已付款",
                                    TITLEWIDTH:[NSNumber numberWithFloat:self.view.width / 3]
                                    },
                                  @{NOMALKEY: @"subTabbar_normal.png",
                                    HEIGHTKEY:@"subTabbar_highLight.png",
                                    TITLEKEY:@"已取消",
                                    TITLEWIDTH:[NSNumber numberWithFloat:self.view.width / 3]
                                    },
                                  ];
    
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, self.view.width, MENUHEIHT) ButtonItems:vButtonItemArray];
        mMenuHriZontal.delegate = self;
    }
    
    [self.view addSubview:mMenuHriZontal];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, mMenuHriZontal.bottom, self.view.width, self.view.height - mMenuHriZontal.bottom)];
    [_contentView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    [self.view addSubview:_contentView];
    
    [self createTableViews];
}

- (void)createTableViews {
    tableViewArray = [NSMutableArray arrayWithCapacity:3];
    
    CustomTableView *notPaidTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height)];
    canceledDND = [[CanceledOrderTableViewDND alloc] init];
    notPaidTableView.delegate = canceledDND;
    notPaidTableView.dataSource = canceledDND;
    
    CustomTableView *paidTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height)];
    //CanceledOrderTableViewDND *paidDND = [[CanceledOrderTableViewDND alloc] init];
    paidTableView.delegate = canceledDND;
    paidTableView.dataSource = canceledDND;
    
    CustomTableView *canceledTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, _contentView.height)];
    //CanceledOrderTableViewDND *paidDND = [[CanceledOrderTableViewDND alloc] init];
    canceledTableView.delegate = canceledDND;
    canceledTableView.dataSource = canceledDND;
    
    [tableViewArray addObject:notPaidTableView];
    [tableViewArray addObject:paidTableView];
    [tableViewArray addObject:canceledTableView];
}

#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    NSLog(@"第%ld个Button点击了",(long)aIndex);
    for (CustomTableView *tableView in tableViewArray) {
        [tableView removeFromSuperview];
    }
    [_contentView addSubview:[tableViewArray objectAtIndex:aIndex]];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSLog(@"CurrentPage:%ld",(long)aPage);
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
    //    if (aPage == 3) {
    //刷新当页数据
    //    }
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
