//
//  TerminalStoreManagerView.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStoreManagerView.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "MJRefresh.h"
#import "TerminalStore.h"
#import "TerminalStoreTableViewCell.h"
#import "TerminalStoreDetailViewController.h"

#define COUNT_PER_LOADING 20

@interface TerminalStoreManagerView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIViewController *rootViewController;

@end;

@implementation TerminalStoreManagerView{
    NSInteger _loadedCount;
    NSMutableArray *headLinesArray;
    NSMutableArray *headImageItemArray;
    NSMutableArray *cellObjectArray;
}

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller{
    self = [super initWithFrame:frame];
    _rootViewController = controller;
    [self initialize];
    return self;
}

-(void)initialize{
    _loadedCount = 0;
    cellObjectArray = [[NSMutableArray alloc] init];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:scrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView.header.autoChangeAlpha = YES;
    
    //下拉刷新
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataByClearAll:YES withComplete:^{
            [_tableView.header endRefreshing];
            [_tableView reloadData];
        }];
    }];
    
    // 上拉刷新
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataByClearAll:NO withComplete:^{
            [_tableView.footer endRefreshing];
            [_tableView reloadData];
        }];
    }];
    
    [_tableView.header beginRefreshing];
}

//从AVCloud查询数据并刷新界面
- (void)loadDataByClearAll:(BOOL)needClearAll withComplete:(void(^)())complete{
    AVRelation *relation = [[ShareInstances getCurrentFinalDealer] relationforKey:@"terminalStores"];
    AVQuery *query = [relation query];
    [query orderByDescending:@"point"];
    query.limit = COUNT_PER_LOADING;
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 3600*24*7;//缓存一周时间
    if (!needClearAll)
        query.skip = self->_loadedCount;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if (needClearAll){
                self->_loadedCount = objects.count;
                [cellObjectArray removeAllObjects];
            }else{
                self->_loadedCount += objects.count;
            }
            
            for (TerminalStore *terminalStore in objects) {
                [cellObjectArray addObject:terminalStore];
            }
            
            if (complete) {
                complete(objects.count);
            }
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
    vCell.isEditMode = NO;
    [vCell setTerminalStore:[cellObjectArray objectAtIndex:indexPath.row]];
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TerminalStoreDetailViewController *terminalStoreDetailVC = [[TerminalStoreDetailViewController alloc] initWithTerminalStore:[cellObjectArray objectAtIndex:indexPath.row]];
    [self.rootViewController.navigationController pushViewController:terminalStoreDetailVC animated:YES];
}


@end
