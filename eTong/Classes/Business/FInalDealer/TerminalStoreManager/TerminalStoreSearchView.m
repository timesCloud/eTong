//
//  TerminalStoreSearchView.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/25.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStoreSearchView.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "MJRefresh.h"
#import "TerminalStore.h"
#import "TerminalStoreTableViewCell.h"
#import "TerminalStoreDetailViewController.h"
#import "TerminalStoreTableView.h"

#define COUNT_PER_LOADING 20

@interface TerminalStoreSearchView()<TerminalStoreTableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) TerminalStoreTableView *tableView;
@property (nonatomic, weak) UIViewController *rootViewController;

@end;

@implementation TerminalStoreSearchView{
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
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
    _searchBar.placeholder = @"请输入店铺名或电话查找";
    _searchBar.delegate = self;
    [self addSubview:_searchBar];
    
    _tableView = [[TerminalStoreTableView alloc] initWithFrame:CGRectMake(0, _searchBar .bottom, self.width, self.height - _searchBar.height) withController:self.rootViewController isEditMode:YES];
    _tableView.tsDelegate = self;
    [self addSubview:_tableView];
}

#pragma marks TerminalStoreTableViewDelegate
-(void)loadDataByClearAll:(BOOL)needClearAll withComplete:(void (^)(NSArray *, BOOL))complete{
    if (![_searchBar.text  isEqual: @""]) {
        AVQuery *query1 = [TerminalStore query];
        [query1 whereKey:@"storeName" hasPrefix:_searchBar.text];
        AVQuery *query2 = [TerminalStore query];
        [query2 whereKey:@"telNo" hasPrefix:[_searchBar text]];
        AVQuery *query = [AVQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query1, query2, nil]];
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
                    complete(cellObjectArray, YES);
                }
            }else{
                if (complete) {
                    complete(nil, NO);
                }
            }
        }];
    }else{
        if (complete) {
            complete(nil, NO);
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _loadedCount = 0;
    [_tableView forceRefreshData];
}

@end
