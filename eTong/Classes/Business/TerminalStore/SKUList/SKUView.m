//
//  SKUView.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SKUView.h"
#import "ShareInstances.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "SKU.h"
#import "Brand.h"
#import "SVProgressHUD.h"
#import "SKUTableViewCell.h"
#import "SKUSearchResultViewController.h"
//#import "DOPDropDownMenu.h"
#import "MJRefresh.h"
#import "StockEntryViewController.h"

#define COUNT_PER_LOADING 9999

@interface SKUView()<UITableViewDelegate, UITableViewDataSource, StockEntryViewDelegate>//, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

@end

@implementation SKUView{
    UITableView *skuTableView;
    NSInteger _loadedCount;
    NSMutableArray *SKUs;
    NSInteger selectedRow;
    //DOPDropDownMenu *dropDownMenu;
    NSMutableArray *brandArray, *brandNameArray;
    Brand *selectedBrand;
    DataOrderType dataOrderType;
}

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeViewController = (RootViewController *)controller;
        SKUs = [[NSMutableArray alloc] init];
        [self initialize];
    }
    return self;
}

-(void)initialize{
//    dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
//    dropDownMenu.dataSource = self;
//    dropDownMenu.delegate = self;
//    [self addSubview:dropDownMenu];
    
    skuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    skuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [skuTableView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    skuTableView.delegate = self;
    skuTableView.dataSource = self;
    selectedRow = -1;
    [self addSubview:skuTableView];
    
    [self initializeMenuItem];//初始化menu必须在初始化刷新控件之前
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    skuTableView.header.autoChangeAlpha = YES;
    
    //下拉刷新
    skuTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataByClearAll:YES withComplete:^{
            [skuTableView.header endRefreshing];
            [skuTableView reloadData];
        }];
    }];
    
    // 上拉刷新
    skuTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataByClearAll:NO withComplete:^{
            [skuTableView.footer endRefreshing];
            [skuTableView reloadData];
        }];
    }];
    
    [skuTableView.header beginRefreshing];
}

- (void)loadDataByClearAll:(BOOL)needClearAll withComplete:(void(^)())complete{
    TerminalStore *curTerminalStore = [ShareInstances getCurrentTerminalStore];
    AVRelation *skuRelation = [curTerminalStore relationforKey:@"sku"];
    AVQuery *query = [skuRelation query];
    
    [query whereKey:@"brand" equalTo:selectedBrand];
    
//    switch (dataOrderType) {
//        case dotStockRateAsc:
//            [query orderByDescending:@"updateAt"];
//            break;
//        case dotStockRateDesc:
//            break;
//        default:
//            break;
//    }
    
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
                [SKUs removeAllObjects];
            }else{
                self->_loadedCount += objects.count;
            }
            
            for (SKU *sku in objects) {
                [SKUs addObject:sku];
            }
            
            if (complete) {
                complete(objects.count);
            }
        }
    }];
}

#pragma marks UITableViewDelegate and UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSKUViewCellUnhighlightHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseId = @"SKUTableViewCell";
    SKUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[SKUTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    SKU *sku = [SKUs objectAtIndex:indexPath.row];
    [cell setSKU:sku];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SKUs.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SKU *sku = [SKUs objectAtIndex:indexPath.row];
    SKUSearchResultViewController *ssrVC = [[SKUSearchResultViewController alloc] initWithSKU:sku];
    ssrVC.skuView = self;
    [_homeViewController.navigationController pushViewController:ssrVC animated:YES];
}

#pragma marks DOPDropDownMenuDelegate
- (void)initializeMenuItem {
    brandArray = [[NSMutableArray alloc] init];
    brandNameArray = [[NSMutableArray alloc] init];
    [brandArray addObject:[NSNumber numberWithInteger:0]];
    [brandNameArray addObject:@"全部品牌"];
    AVRelation *relation = [[ShareInstances getCurrentTerminalStore] relationforKey:@"brand"];
    AVQuery *query = [relation query];
    [query orderByAscending:@"order"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 3600 * 24 * 7;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (Brand *brand in objects) {
                [brandArray addObject:brand];
                [brandNameArray addObject:brand.brandName];
            }
            
            if (brandArray.count > 1) {
                selectedBrand = [brandArray objectAtIndex:1];
            }
        }
    }];
    
    dataOrderType = dotStockRateAsc;
}

//- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
//    return 2;
//}
//
//- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
//    switch (column) {
//        case 0:
//            return [brandNameArray count];
//            break;
//        case 1:
//            return DataOrderTypeCount;
//            break;
//        default:
//            return 0;
//            break;
//    }
//}
//
//- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
//    switch (indexPath.column) {
//        case 0:
//            return [brandNameArray objectAtIndex:indexPath.row];
//            break;
//        case 1:
//            return DataOrderTypeString(indexPath.row);
//            break;
//        default:
//            return nil;
//            break;
//    }
//}
//
//- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
//    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
//    NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
//    //NSString *title = [menu titleForRowAtIndexPath:indexPath];
//    
//    switch (indexPath.column) {
//        case 0:{
//            selectedBrand = [brandArray objectAtIndex:indexPath.row];
//            [self loadDataByClearAll:YES withComplete:^{
//                [skuTableView reloadData];
//            }];
//            break;
//        }
//        case 1:
//            dataOrderType = (DataOrderType)indexPath.row;
//            break;
//        default:
//            break;
//    }
//}

#pragma marks StockEntryViewDelegate
-(void)stockDataChanged:(SKU *)sku{
    NSInteger index = [SKUs indexOfObject:sku];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [skuTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}


@end
