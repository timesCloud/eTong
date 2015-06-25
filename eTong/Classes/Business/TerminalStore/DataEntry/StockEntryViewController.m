//
//  StockEntryView.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StockEntryViewController.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "SKU.h"
#import "Stock.h"
#import "Purchases.h"
#import "SVProgressHUD.h"
#import "CustomDatePickerView.h"
#import "NormalNavigationBar.h"
#import "PackingStockTableViewCell.h"

@interface StockEntryViewController()<CustomDatePickerViewDelegate, NormalNavigationDelegate, UITableViewDataSource, UITableViewDelegate, PackingStockTableViewCellDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation StockEntryViewController{
    UIImageView *skuImage;
    UILabel *skuNameLable;
    UILabel *hintLabel;
    UILabel *dtLabel;
    UITableView *packingTabelView;
    
    NSDate *selectedDate;
    SKU *curSKU;
    NSInteger curMode;
    NSArray *packings;
    NSMutableArray *stockArray;
    NSMutableArray *purchaseArray;
    
    NSInteger lastStockAfterPurchase;
}

- (instancetype)initWithSku:(SKU *)sku mode:(NSInteger)mode{
    self = [super init];
    
    curSKU = sku;
    curMode = mode;
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *titleString = curSKU == 1 ? @"库存录入" : @"进货录入";
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:titleString];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    //SKU
    UILabel *skuTitle = [ShareInstances addSubTitleLabel:@"sku" withFrame:CGRectMake(MARGIN_NARROW, self.navigationBar.bottom + MARGIN_NARROW, self.view.width, TEXTSIZE_SUBTITLE) withSuperView:self.view];
    
    UIView *skuView = [[UIView alloc] initWithFrame:CGRectMake(0, skuTitle.bottom + MARGIN_NARROW, self.view.width, 100)];
    [ShareInstances addTopBottomBorderOnView:skuView];
    [skuView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:skuView];
    
    skuImage = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, skuView.height - MARGIN_NARROW * 2, skuView.height - MARGIN_NARROW * 2)];
    [skuView addSubview:skuImage];
    [curSKU.image getThumbnail:YES width:180 height:180 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [skuImage setImage:image];
        }
    }];
    
    skuNameLable = [ShareInstances addLabel:curSKU.skuName withFrame:CGRectMake(skuImage.right + MARGIN_NARROW, 20, self.view.width - skuImage.right * 2 - MARGIN_NARROW, TEXTSIZE_BIG) withSuperView:skuView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    //时间
    UILabel *dtTitle = [ShareInstances addSubTitleLabel:@"库存盘点日期" withFrame:CGRectMake(MARGIN_NARROW, skuView.bottom + MARGIN_NARROW, self.view.width, TEXTSIZE_SUBTITLE) withSuperView:self.view];
    
    UIView *dtView = [[UIView alloc] initWithFrame:CGRectMake(0, dtTitle.bottom + MARGIN_NARROW, self.view.width, 44)];
    [dtView setBackgroundColor:[UIColor whiteColor]];
    [ShareInstances addGoIndicateOnView:dtView];
    [ShareInstances addTopBottomBorderOnView:dtView];
    [self.view addSubview:dtView];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    selectedDate = [NSDate date];
    dtLabel = [ShareInstances addLabel:[dateFormatter stringFromDate:selectedDate] withFrame:CGRectMake(MARGIN_NARROW, (44 - TEXTSIZE_BIG) / 2, dtView.width - 44 - MARGIN_NARROW, TEXTSIZE_BIG) withSuperView:dtView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    [dtView addSubview:dtLabel];
    UITapGestureRecognizer *dtTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnEditEntryDate)];
    [dtView addGestureRecognizer:dtTapGR];
    
    //库存量
    UILabel *countTitle = [ShareInstances addSubTitleLabel:@"库存数量" withFrame:CGRectMake(MARGIN_NARROW, dtView.bottom + MARGIN_NARROW, self.view.width, TEXTSIZE_SUBTITLE) withSuperView:self.view];
    
    UIView *tableBgView = [[UIView alloc] initWithFrame:CGRectMake(0, countTitle.bottom + MARGIN_NARROW, self.view.width, self.view.height - countTitle.bottom - MARGIN_NARROW - 44 - MARGIN_NARROW)];
    [ShareInstances addTopBottomBorderOnView:tableBgView];
    [self.view addSubview:tableBgView];
    
    packingTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, tableBgView.width, tableBgView.height - 1)];
    packingTabelView.delegate = self;
    packingTabelView.dataSource = self;
    packingTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableBgView addSubview:packingTabelView];

    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    [submitButton setBackgroundColor:[UIColor orangeColor]];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(SubmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    [self loadPackings];
    [self loadLastPurchase];
}

-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)OnEditEntryDate{
    CustomDatePickerView *customDatePickerView = [[CustomDatePickerView alloc] initWithFrame:self.view.frame withDefaultDate:selectedDate];
    customDatePickerView.delegate = self;
    [self.view addSubview:customDatePickerView];
}

- (void)dateChanged:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    selectedDate = date;
    [dtLabel setText:[dateFormatter stringFromDate:selectedDate]];
}

-(void)loadPackings{
    AVRelation *relation = [curSKU relationforKey:@"packingSpecification"];
    AVQuery *query = [relation query];
    [query orderByAscending:@"order"];
    [SVProgressHUD showWithStatus:@"正在查询包装规格"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                [SVProgressHUD dismiss];
                packings = objects;
                [self initStockArray];
                [packingTabelView reloadData];
            }else{
                [SVProgressHUD dismissWithError:@"没有查到SKU相应的包装规格" afterDelay:2];
            }
        } else{
            [SVProgressHUD dismissWithError:@"网络错误，未能查询到包装规格" afterDelay:2];
        }
    }];
}

-(void)loadLastPurchase{
    AVQuery *query = [Stock query];
    [query whereKey:@"store" equalTo:[ShareInstances getCurrentTerminalStore]];
    [query whereKey:@"sku" equalTo:curSKU];
    [query whereKey:@"updateFrom" equalTo:[NSNumber numberWithInteger:2]];
    [query orderByDescending:@"date"];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            Stock *stock = [objects objectAtIndex:0];
            lastStockAfterPurchase = [stock.stock integerValue];
        }
    }];
}

-(void)initStockArray{
    stockArray = [[NSMutableArray alloc] init];
    purchaseArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < packings.count; i++) {
        [stockArray addObject:[NSNumber numberWithInt:0]];
        [purchaseArray addObject:[NSNumber numberWithInt:0]];
    }
}

-(void)SubmitButtonClick{
    NSInteger stockTotal = 0;
    NSInteger purchaseTotal = 0;
    for (int i = 0; i < packings.count; i++) {
        stockTotal += [[stockArray objectAtIndex:i] integerValue];
        purchaseTotal += [[purchaseArray objectAtIndex:i] integerValue];
    }
    if (curMode == 1) {
        if (stockTotal > lastStockAfterPurchase) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据不符" message:@"您录入的当前库存总数已经超过了最近一次进货后的总库存量，请检查。如果库存确实有增长，请先录入进货记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"转到进货录入", nil];
            [alertView show];
        } else{
            Stock *stock = [Stock object];
            stock.sku = curSKU;
            stock.store = [ShareInstances getCurrentTerminalStore];
            stock.date = selectedDate;
            stock.stock = [NSNumber numberWithInteger:stockTotal];
            stock.updateFrom = [NSNumber numberWithInteger:1];
            [SVProgressHUD showSuccessWithStatus:@"录入完成" duration:2];
            [stock saveEventually:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    if ([_delegate respondsToSelector:@selector(stockDataChanged:)]) {
                        [_delegate stockDataChanged:curSKU];
                    }
                }
            }];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }else{
        Purchases *purchases = [Purchases object];
        purchases.sku = curSKU;
        purchases.store = [ShareInstances getCurrentTerminalStore];
        purchases.date = selectedDate;
        purchases.count = [NSNumber numberWithInteger:purchaseTotal];
        purchases.stockCountBeforePurchase = [NSNumber numberWithInteger:stockTotal];
        [SVProgressHUD showSuccessWithStatus:@"录入完成" duration:2];
        [purchases saveEventually:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if ([_delegate respondsToSelector:@selector(stockDataChanged:)]) {
                    [_delegate stockDataChanged:curSKU];
                }
            }
        }];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}

#pragma marks UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [packings count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = @"packingCell";
    PackingStockTableViewCell *cell = [packingTabelView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[PackingStockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid entryMode:curMode];
        cell.delegate = self;
    }
    
    [cell setPackingSpecification:[packings objectAtIndex:indexPath.row]];
    return cell;
}

-(void)packing:(PackingSpecification *)packing StockEntried:(NSInteger)stock{
    NSInteger index = [packings indexOfObject:packing];
    [stockArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:(int)([packing.containsCount integerValue] * stock)]];
}

-(void)packing:(PackingSpecification *)packing PurchaseEntried:(NSInteger)purchase{
    NSInteger index = [packings indexOfObject:packing];
    [purchaseArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:(int)([packing.containsCount integerValue] * purchase)]];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        StockEntryViewController *stockEntryVC = [[StockEntryViewController alloc] initWithSku:curSKU mode:2];
        [self.navigationController pushViewController:stockEntryVC animated:YES];
    } else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
