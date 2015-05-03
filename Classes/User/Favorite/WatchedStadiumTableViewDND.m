//
//  WatchedStadiumTableViewDND.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "WatchedStadiumTableViewDND.h"
#import "WatchedStadiumTableViewCell.h"

#define COUNT_PER_LOADING 10

@interface WatchedStadiumTableViewDND()

@end

@implementation WatchedStadiumTableViewDND{
    NSInteger _loadedCount;
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView{
    return aView.tableInfoArray.count;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    static NSString *vCellIdentify = @"watchedStadiumCell";
    WatchedStadiumTableViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[WatchedStadiumTableViewCell alloc] init];
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Stadium *stadium = (Stadium *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    [vCell setStadium:stadium];
    //[vCell initialize];
    
    return vCell;
}

#pragma mark CustomTableViewDelegate

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    if(aIndexPath.row < _loadedCount)
        return [WatchedStadiumTableViewCell cellHeight];
    else
        return 50;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    Stadium *stadium = (Stadium *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
//    if ([_delegate respondsToSelector:@selector(showStadium:)]) {
//        [_delegate showStadium: stadium];
//    }
}

//从AVCloud查询数据并刷新界面
- (void)QueryFromAVCloudAndFillView:(CustomTableView *)aView afterClearAll:(BOOL)isAfterClearAll withComplete:(void(^)())complete{
    AVRelation *relation = [[AVUser currentUser] relationforKey:@"watchedStadium"];
    AVQuery *query = [relation query];
    query.limit = COUNT_PER_LOADING;
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 3600*24*7;//缓存一周时间
    if (!isAfterClearAll)
        query.skip = self->_loadedCount;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if (isAfterClearAll){
                self->_loadedCount = objects.count;
                [aView.tableInfoArray removeAllObjects];
            }else{
                self->_loadedCount += objects.count;
            }
            
            for (Stadium *stadium in objects) {
                [aView.tableInfoArray addObject:stadium];
            }
            
            if (complete) {
                complete(objects.count);
            }
        }
    }];
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView{
    [self QueryFromAVCloudAndFillView:aView afterClearAll:false withComplete:complete];
}

-(void)refreshData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView{
    [self QueryFromAVCloudAndFillView:aView afterClearAll:true withComplete:complete];
}

- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView{
    return  aView.reloading;
}


@end
