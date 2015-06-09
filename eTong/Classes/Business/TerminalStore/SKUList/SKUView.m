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
#import "SVProgressHUD.h"
#import "SKUTableViewCell.h"
#import "SKUSearchResultViewController.h"
//#import "DOPDropDownMenu.h"

@interface SKUView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SKUView{
    //DOPDropDownMenu *dropDownMenu;
    UITableView *skuTableView;
    NSMutableArray *SKUs;
    NSInteger selectedRow;
}

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeViewController = (RootViewController *)controller;
        [self initialize];
    }
    return self;
}

-(void)initialize{
    skuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    skuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [skuTableView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    skuTableView.delegate = self;
    skuTableView.dataSource = self;
    selectedRow = -1;
    [self addSubview:skuTableView];
    [self refreshData];
}

-(void)refreshData{
    if (SKUs == nil) {
        SKUs = [[NSMutableArray alloc] init];
    }
    
    TerminalStore *curTerminalStore = [ShareInstances getCurrentTerminalStore];
    AVRelation *skuRelation = [curTerminalStore relationforKey:@"sku"];
    AVQuery *query = [skuRelation query];
    [SVProgressHUD showWithStatus:@"正在查询本店SKU列表"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                [SVProgressHUD dismiss];
                for (SKU *sku in objects) {
                    [SKUs addObject:sku];
                }
                [skuTableView reloadData];
            } else {
                [SVProgressHUD dismissWithError:@"本店尚未录入过SKU，请直接使用条码扫描或联系客服" afterDelay:4];
            }
        } else{
            [SVProgressHUD dismissWithError:@"网络故障，查询失败" afterDelay:2];
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
//    if (indexPath.row != selectedRow) {
//        NSIndexPath *lastSelectedIndexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
//        selectedRow = indexPath.row;
//        [tableView reloadRowsAtIndexPaths:@[lastSelectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
    SKU *sku = [SKUs objectAtIndex:indexPath.row];
    SKUSearchResultViewController *ssrVC = [[SKUSearchResultViewController alloc] initWithSKU:sku];
    [_homeViewController.navigationController pushViewController:ssrVC animated:YES];
}

@end
