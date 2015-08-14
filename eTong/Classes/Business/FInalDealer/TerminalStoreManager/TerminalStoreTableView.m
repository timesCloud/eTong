//
//  TerminalStoreTableView.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/25.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStoreTableView.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "MJRefresh.h"
#import "TerminalStore.h"
#import "TerminalStoreTableViewCell.h"
#import "TerminalStoreDetailViewController.h"
#import "SVProgressHUD.h"

#define COUNT_PER_LOADING 20

@interface TerminalStoreTableView()<UITableViewDelegate, UITableViewDataSource, TerminalStoreTableViewCellDelegate>

@property (nonatomic, weak) UIViewController *rootViewController;

@end;

@implementation TerminalStoreTableView{
    NSInteger _loadedCount;
    NSMutableArray *headLinesArray;
    NSMutableArray *headImageItemArray;
    NSMutableArray *cellObjectArray;
    NSMutableArray *containedObjectArray;
    NSMutableArray *appliedObjectArray;//已提交添加申请的终端店
    BOOL editMode;
}

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller isEditMode:(BOOL)isEditMode{
    self = [super initWithFrame:frame];
    _rootViewController = controller;
    editMode = isEditMode;
    [self initialize];
    return self;
}

-(void)initialize{
    _loadedCount = 0;
    cellObjectArray = [[NSMutableArray alloc] init];
    
    self.delegate = self;
    self.dataSource = self;
    [self queryContainedObjects];
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.header.autoChangeAlpha = YES;
    
    //下拉刷新
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if([_tsDelegate respondsToSelector:@selector(loadDataByClearAll:withComplete:)]){
            [_tsDelegate loadDataByClearAll:YES withComplete:^(NSArray *data, BOOL successed) {
                if (successed) {
                    cellObjectArray = [NSMutableArray arrayWithArray:data];
                }
                [self.header endRefreshing];
                [self reloadData];
            }];
        }
    }];
    
    // 上拉刷新
    self.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if([_tsDelegate respondsToSelector:@selector(loadDataByClearAll:withComplete:)]){
            [_tsDelegate loadDataByClearAll:NO withComplete:^(NSArray *data, BOOL successed) {
                if (successed) {
                    cellObjectArray = [NSMutableArray arrayWithArray:data];;
                }
                [self.header endRefreshing];
                [self reloadData];
            }];
        }
    }];
}

-(void)forceRefreshData{
    [self.header beginRefreshing];
}

-(void)queryContainedObjects{
    AVRelation *relation = [[ShareInstances getCurrentFinalDealer] relationforKey:@"terminalStores"];
    AVQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            containedObjectArray = [NSMutableArray arrayWithArray:objects];
        }
    }];
    
    AVRelation *relation1 = [[ShareInstances getCurrentFinalDealer] relationforKey:@"appliedStores"];
    AVQuery *query1 = [relation1 query];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            appliedObjectArray = [NSMutableArray arrayWithArray:objects];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellObjectArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTerminalStoreCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *vCellIdentify = @"TerminalManagerCell";
    TerminalStoreTableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[TerminalStoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
    }
    
    vCell.selectionStyle = UITableViewCellSelectionStyleNone;
    vCell.delegate = self;
    vCell.isEditMode = ![containedObjectArray containsObject:[cellObjectArray objectAtIndex:indexPath.row]];
    vCell.isContained = [appliedObjectArray containsObject:[cellObjectArray objectAtIndex:indexPath.row]];
    [vCell setTerminalStore:[cellObjectArray objectAtIndex:indexPath.row]];
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([containedObjectArray containsObject:[cellObjectArray objectAtIndex:indexPath.row]]) {
        TerminalStoreDetailViewController *terminalStoreDetailVC = [[TerminalStoreDetailViewController alloc] initWithTerminalStore:[cellObjectArray objectAtIndex:indexPath.row]];
        [self.rootViewController.navigationController pushViewController:terminalStoreDetailVC animated:YES];
    }
}

-(void)terminalStoreCellRightButtonClick:(TerminalStore *)terminalStore{
    AVRelation *relation = [[ShareInstances getCurrentFinalDealer] relationforKey:@"appliedStores"];
    if ([appliedObjectArray containsObject:terminalStore]) {
        [relation removeObject:terminalStore];
        [SVProgressHUD showWithStatus:@"正在撤回申请"];
        [[ShareInstances getCurrentFinalDealer] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [appliedObjectArray removeObject:terminalStore];
                [SVProgressHUD dismissWithSuccess:@"撤回成功" afterDelay:2];
                [self reloadData];
            }else{
                [SVProgressHUD dismissWithError:@"撤回失败" afterDelay:2];
            }
        }];
    }else{
        [relation addObject:terminalStore];
        [SVProgressHUD showWithStatus:@"正在提交申请"];
        [[ShareInstances getCurrentFinalDealer] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [appliedObjectArray addObject:terminalStore];
                [SVProgressHUD dismissWithSuccess:@"提交成功，请等待系统审核" afterDelay:2];
                [self reloadData];
            }else{
                [SVProgressHUD dismissWithError:@"提交申请失败" afterDelay:2];
            }
        }];
    }
    
}


@end
