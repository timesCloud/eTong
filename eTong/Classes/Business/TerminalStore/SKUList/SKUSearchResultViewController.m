//
//  SKUSearchResultViewController.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/18.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SKUSearchResultViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "UIView+XD.h"
#import "SKU.h"
#import "StockEntryView.h"

@interface SKUSearchResultViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation SKUSearchResultViewController{
    SKU *curSKU;
}

-(instancetype)initWithSKU:(SKU *)sku{
    self = [super init];
    curSKU = sku;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"SKU详情"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    UIView *scrollView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, self.view.width, self.view.height - self.navigationBar.bottom - 45)];
    [self.view addSubview:scrollView];
    
    //SKU
    UIImageView *skuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.width)];
    [scrollView addSubview:skuImage];
    [curSKU.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            [skuImage setImage:[UIImage imageWithData:data]];
        }
    }];
    
    UILabel *nameLabel = [ShareInstances addLabel:curSKU.skuName withFrame:CGRectMake(MARGIN_WIDE, skuImage.bottom + MARGIN_WIDE, self.view.width - MARGIN_WIDE * 2, TEXTSIZE_BIG) withSuperView:scrollView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 44.5, self.view.width, 44.5)];
    [ShareInstances addTopBottomBorderOnView:buttonView];
    [self.view addSubview:buttonView];
    
    UIButton *stockEntryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.5, buttonView.width / 2, 44)];
    [stockEntryButton setBackgroundColor:MAIN_COLOR];
    [stockEntryButton setTitle:@"库存盘点" forState:UIControlStateNormal];
    [stockEntryButton addTarget:self action:@selector(stockEntryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:stockEntryButton];
    
    UIButton *purchaseEntryButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonView.width / 2, 0.5, buttonView.width / 2, 44)];
    [purchaseEntryButton setBackgroundColor:MAIN_COLOR_1];
    [purchaseEntryButton setTitle:@"进货录入" forState:UIControlStateNormal];
    [purchaseEntryButton addTarget:self action:@selector(purchasesEntryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:purchaseEntryButton];
}

-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)stockEntryButtonClick{
    StockEntryViewController *stockEntryVC = [[StockEntryViewController alloc] initWithSku:curSKU mode:1];
    [self.navigationController pushViewController:stockEntryVC animated:YES];
}

-(void)purchasesEntryButtonClick{
    StockEntryViewController *purchasesEntryVC = [[StockEntryViewController alloc] initWithSku:curSKU mode:2];
    [self.navigationController pushViewController:purchasesEntryVC animated:YES];
}

@end
