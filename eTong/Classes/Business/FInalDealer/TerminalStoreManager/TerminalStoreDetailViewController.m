//
//  TerminalStoreDetailViewController.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStoreDetailViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "UIView+XD.h"
#import "TerminalStore.h"
#import "SKUTableViewCell.h"
#import "MJRefresh.h"
#import "TelHelper.h"
#import "PreNavigationViewController.h"
#import "StockEntryViewController.h"

#define COUNT_PER_LOADING 9999

@interface TerminalStoreDetailViewController()<NormalNavigationDelegate, UITableViewDelegate, UITableViewDataSource, StockEntryViewDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation TerminalStoreDetailViewController{
    TerminalStore *curTerminalStore;
    UIImageView *headerImageView;
    UILabel *titleLabel, *summaryLabel, *distanceLabel;
    UITableView *stockTableView;
    NSInteger _loadedCount;
    NSMutableArray *SKUs;
    UIView *headerView;
}

-(instancetype)initWithTerminalStore:(TerminalStore *)terminalStore{
    self = [super init];
    curTerminalStore = terminalStore;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"终端店详情"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    [self initHeaderView];
    
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    stockTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, size.width, size.height)];
    stockTableView.delegate = self;
    stockTableView.dataSource = self;
    stockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    stockTableView.tableHeaderView = headerView;
    [self.view addSubview:stockTableView];
    
    SKUs = [[NSMutableArray alloc] init];
    
    [self setupRefresh];
}

-(void)initHeaderView{
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 100)];
    [headerView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    UIView *summaryView = [[UIScrollView alloc] initWithFrame:CGRectMake(MARGIN_WIDE, MARGIN_WIDE, size.width - MARGIN_WIDE * 2, 100)];
    [summaryView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:summaryView];
    
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_WIDE, MARGIN_WIDE, 100 - MARGIN_WIDE * 2, 100 - MARGIN_WIDE * 2)];
    headerImageView.layer.cornerRadius = 4.0f;
    headerImageView.layer.masksToBounds = YES;
    [summaryView addSubview:headerImageView];
    [curTerminalStore.shopFrontPhoto getThumbnail:YES width:160 height:160 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [headerImageView setImage:image];
            
        }
    }];
    titleLabel = [ShareInstances addLabel:curTerminalStore.storeName withFrame:CGRectMake(headerImageView.right + MARGIN_WIDE, headerImageView.y, size.width - headerImageView.right - MARGIN_WIDE - 44, TEXTSIZE_BIG) withSuperView:summaryView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    NSInteger nextStarOriginX = titleLabel.x;
    for (int i = 0; i < 5; i++) {//todo:替换为实际的价值评分
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nextStarOriginX, titleLabel.bottom + MARGIN_WIDE, 20, 20)];
        [starImageView setImage:[UIImage imageNamed:@"star_bordered.png"]];
        starImageView.contentMode = UIViewContentModeCenter;
        [summaryView addSubview:starImageView];
        
        nextStarOriginX += 24;
    }
    
    summaryLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(titleLabel.x, titleLabel.bottom + 20 + MARGIN_WIDE * 2, titleLabel.width, headerImageView.height - titleLabel.bottom) withSuperView:summaryView withTextColor:LIGHT_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_SUBTITLE];
    
    //联系方式等视图
    UILabel *contactTitleLabel = [ShareInstances addSubTitleLabel:@"联系方式" withFrame:CGRectMake(MARGIN_WIDE, summaryView.bottom + MARGIN_WIDE, summaryView.width - MARGIN_WIDE * 2, TEXTSIZE_SUBTITLE) withSuperView:headerView];
    
    UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(self.view.x, contactTitleLabel.bottom + MARGIN_WIDE, self.view.width, 90)];
    contactView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:contactView];
    
    UILabel *nameLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(MARGIN_WIDE, MARGIN_WIDE, contactView.width - 80, 18) withSuperView:contactView withTextColor:[UIColor darkGrayColor] withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    [curTerminalStore.shopKeeper fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            [nameLabel setText:[NSString stringWithFormat:@"负责人：%@", [object objectForKey:@"nickname"]]];
        }
    }];
    
    distanceLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(contactView.width - 44 * 2 - MARGIN_WIDE - 80, MARGIN_WIDE, 80, 20) withSuperView:contactView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentRight withTextSize:TEXTSIZE_SUBTITLE];
    
    UIView *verSplitterView = [[UIView alloc] initWithFrame:CGRectMake(distanceLabel.right + MARGIN_WIDE, MARGIN_WIDE, 0.5, nameLabel.bottom + 10)];
    verSplitterView.backgroundColor = SPLITTER_COLOR;
    [contactView addSubview:verSplitterView];
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(contactView.width - 44, 0, 44, 44)];
    [mapButton setImage:[UIImage imageNamed:@"map_normal.png"] forState:UIControlStateNormal];
    [mapButton setContentMode:UIViewContentModeCenter];
    [mapButton addTarget:self action:@selector(doShowMap) forControlEvents:UIControlEventTouchUpInside];
    [contactView addSubview:mapButton];
    
    UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(mapButton.x - 44, 0, 44, 44)];
    [telButton setImage:[UIImage imageNamed:@"callout_normal.png"] forState:UIControlStateNormal];
    [telButton setContentMode:UIViewContentModeCenter];
    [telButton addTarget:self action:@selector(doCall) forControlEvents:UIControlEventTouchUpInside];
    [contactView addSubview:telButton];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    [addressLabel setFont:[UIFont systemFontOfSize:14]];
    [addressLabel setTextColor:NORMAL_TEXT_COLOR];
    [addressLabel setText:curTerminalStore.address];
    NSDictionary *attribute = @{NSFontAttributeName:addressLabel.font};
    CGSize boundingSize = CGSizeMake(contactView.width - MARGIN_WIDE * 2, 100);
    CGSize requiredSize = [addressLabel.text boundingRectWithSize:boundingSize options:NSStringDrawingTruncatesLastVisibleLine |
                           NSStringDrawingUsesLineFragmentOrigin |
                           NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [addressLabel setFrame:CGRectMake(MARGIN_WIDE, nameLabel.bottom + 15 + MARGIN_WIDE, requiredSize.width, requiredSize.height)];
    addressLabel.numberOfLines = 0;
    [contactView addSubview:addressLabel];
    
    [contactView setHeight:addressLabel.bottom + MARGIN_WIDE];
    
    UILabel *stockTitleLabel = [ShareInstances addSubTitleLabel:@"库存情况" withFrame:CGRectMake(MARGIN_WIDE, contactView.bottom + MARGIN_WIDE, contactView.width - MARGIN_WIDE * 2, TEXTSIZE_SUBTITLE) withSuperView:headerView];
    
    [headerView setHeight:stockTitleLabel.bottom + MARGIN_WIDE];
}

- (void)setupRefresh
{
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    stockTableView.header.autoChangeAlpha = YES;
    
    //下拉刷新
    stockTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataByClearAll:YES withComplete:^{
            [stockTableView.header endRefreshing];
            [stockTableView reloadData];
        }];
    }];
    
    // 上拉刷新
    stockTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataByClearAll:NO withComplete:^{
            [stockTableView.footer endRefreshing];
            [stockTableView reloadData];
        }];
    }];
    
    [stockTableView.header beginRefreshing];
}

- (void)loadDataByClearAll:(BOOL)needClearAll withComplete:(void(^)())complete{
    AVRelation *skuRelation = [curTerminalStore relationforKey:@"sku"];
    AVQuery *query = [skuRelation query];
    
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
    return kSKUViewCellUnhighlightHeight - 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseId = @"StockTableViewCell";
    SKUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[SKUTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    SKU *sku = [SKUs objectAtIndex:indexPath.row];
    cell.curTerminalStore = curTerminalStore;
    [cell setSKU:sku];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return SKUs.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SKU *sku = [SKUs objectAtIndex:indexPath.row];
    StockEntryViewController *seVC = [[StockEntryViewController alloc] initWithSku:sku mode:3];
    seVC.curTerminalStore = curTerminalStore;
    seVC.delegate = self;
    [self.navigationController pushViewController:seVC animated:YES];
}

-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doCall {
    if ((![curTerminalStore.telNo isEqualToString:@""]) && (curTerminalStore.telNo != nil)) {
        [TelHelper callWithParentView:self.view phoneNo:curTerminalStore.telNo];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该商家暂未登记电话" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)doShowMap {
    PreNavigationViewController *pnVC = [[PreNavigationViewController alloc] initWithLocation:curTerminalStore.location withTargetPortrait:curTerminalStore.shopFrontPhoto withTitle:curTerminalStore.storeName withSubTitle:[NSString stringWithFormat:@"电话号码:%@", curTerminalStore.telNo]];
    [self.navigationController pushViewController:pnVC animated:YES];
}


#pragma marks StockEntryViewController
-(void)stockDataChanged:(SKU *)sku{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[SKUs indexOfObject:sku] inSection:0];
    [stockTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}


@end
