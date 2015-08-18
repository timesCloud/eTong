//
//  HomeView.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "HomeView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "Article.h"
#import "MJRefresh.h"
#import "NewsViewCell.h"
#import "MBProgressHUD+MJ.h"
#define COUNT_PER_LOADING 20
#import "NLWebViewController.h"
NSString *const TableViewCellIdentifier = @"NewsCell";

@interface HomeView()<SGFocusImageFrameDelegate, UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIViewController *rootViewController;

@end

@implementation HomeView{
    SGFocusImageFrame *_bannerView;
    NSInteger _loadedCount;
    NSMutableArray *headLinesArray;
    NSMutableArray *headImageItemArray;
    NSMutableArray *articleArray;
}

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller{
    self = [super initWithFrame:frame];
    _rootViewController = controller;
    [self initialize];
    return self;
}

-(void)initialize{
    _loadedCount = 0;
    articleArray = [[NSMutableArray alloc] init];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:scrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [_tableView registerClass:[NewsViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    [self setupRefresh];
    
    _bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, self.width, 180) delegate:self imageItems:nil isAuto:NO];
    //[scrollView addSubview:_bannerView];
    [self loadHeaderImages];
    
    _tableView.tableHeaderView = _bannerView;
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
    AVQuery *query = [Article query];
    [query whereKey:@"tag" containsAllObjectsInArray:@[@"news"]];
    [query orderByAscending:@"date"];
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
                [articleArray removeAllObjects];
            }else{
                self->_loadedCount += objects.count;
            }
            
            for (Article *article in objects) {
                [articleArray addObject:article];
            }
            
            if (complete) {
                complete(objects.count);
            }
        }
    }];
    
    [self loadHeaderImages];
}

- (void)loadHeaderImages {
    AVQuery *query = [Article query];
    [query whereKeyExists:@"headerImageFile"];
    [query whereKey:@"tag" equalTo:@"ads"];
    [query orderByDescending:@"date"];
    query.limit = 6;
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.maxCacheAge = 3600*24*7;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            NSMutableArray *tempArray = [NSMutableArray array];
            if (headLinesArray == NULL)
                headLinesArray = [NSMutableArray array];
            [headLinesArray removeAllObjects];
            for (Article *article in objects) {
                [headLinesArray addObject:article];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      article.title, @"title" ,
                                      article.headerImageFile, @"image",
                                      nil];
                [tempArray addObject:dict];
            }
            
            int length = (int)objects.count;
            
            headImageItemArray = [NSMutableArray arrayWithCapacity:length+2];
            //添加最后一张图 用于循环
            if (length > 1)
            {
                NSDictionary *dict = [tempArray objectAtIndex:length-1];
                SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
                [headImageItemArray addObject:item];
            }
            for (int i = 0; i < length; i++)
            {
                NSDictionary *dict = [tempArray objectAtIndex:i];
                SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
                [headImageItemArray addObject:item];
                
            }
            //添加第一张图 用于循环
            if (length >1)
            {
                NSDictionary *dict = [tempArray objectAtIndex:0];
                SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
                [headImageItemArray addObject:item];
            }
            
            [self->_bannerView changeImageViewsContent:headImageItemArray];
        }
    }];
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%ld",__FUNCTION__,(long)item.tag);
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [articleArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kArticleCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *vCellIdentify = @"newsCell";
    NewsViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[NewsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
    }
    
    vCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [vCell setArticle:[articleArray objectAtIndex:indexPath.row]];
    
    return vCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article=articleArray[indexPath.row];
    NSString *urlStr=article.url;
    NLWebViewController *webVC=[[NLWebViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:webVC];
    webVC.urlStr=urlStr;
    webVC.title=article.title;
    //[self.rootViewController.navigationController pushViewController:webVC animated:YES];
    [self.rootViewController presentViewController:nav animated:YES completion:^{
        
    }];
    
    NSLog(@"ffff");

}


@end
