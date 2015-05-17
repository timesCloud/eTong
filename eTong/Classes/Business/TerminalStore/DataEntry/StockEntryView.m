//
//  StockEntryView.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StockEntryView.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "BarcodeScanViewController.h"
#import "SKU.h"
#import "SVProgressHUD.h"
#import "CustomDatePickerView.h"

@interface StockEntryView()<CustomDatePickerViewDelegate>

@end

@implementation StockEntryView{
    UIImageView *skuImage;
    UILabel *skuNameLable;
    UILabel *hintLabel;
    UILabel *dtLabel;
    
    NSDate *selectedDate;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self initialize];
    
    return self;
}

- (void)initialize{
    [self setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    //SKU
    UILabel *skuTitle = [ShareInstances addSubTitleLabel:@"sku" withFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, self.width, TEXTSIZE_SUBTITLE) withSuperView:self];
    
    UIView *skuView = [[UIView alloc] initWithFrame:CGRectMake(0, skuTitle.bottom + MARGIN_NARROW, self.width, 100)];
    [ShareInstances addTopBottomBorderOnView:skuView];
    [skuView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:skuView];
    
    skuImage = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, skuView.height - MARGIN_NARROW * 2, skuView.height - MARGIN_NARROW * 2)];
    [skuView addSubview:skuImage];
    
    skuNameLable = [ShareInstances addLabel:@"" withFrame:CGRectMake(skuImage.right + MARGIN_NARROW, 20, self.width - skuImage.right * 2 - MARGIN_NARROW, TEXTSIZE_TITLE) withSuperView:skuView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_TITLE];
    
    hintLabel = [ShareInstances addLabel:@"点击右侧按钮扫描条码，获取SKU" withFrame:CGRectMake(skuImage.x + MARGIN_NARROW, (skuView.height - TEXTSIZE_TITLE) / 2, self.width - skuImage.right - MARGIN_NARROW, TEXTSIZE_TITLE) withSuperView:skuView withTextColor:LINK_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_TITLE];
    
    UIView *verticalSplitter = [[UIView alloc] initWithFrame:CGRectMake(skuNameLable.right + MARGIN_NARROW, MARGIN_NARROW, 1, skuView.height - MARGIN_NARROW * 2)];
    [verticalSplitter setBackgroundColor:SPLITTER_COLOR];
    [skuView addSubview:verticalSplitter];
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(skuView.width - 100 + MARGIN_NARROW * 2, MARGIN_NARROW, 100 - MARGIN_NARROW * 2, 100 - MARGIN_NARROW * 2)];
    [scanButton setImage:[UIImage imageNamed:@"barcode_normal.png"] forState:UIControlStateNormal];
    [scanButton setImage:[UIImage imageNamed:@"barcode_highlight.png"] forState:UIControlStateHighlighted];
    [scanButton setContentMode:UIViewContentModeCenter];
    [scanButton addTarget:self action:@selector(scanBarcode) forControlEvents:UIControlEventTouchUpInside];
    [skuView addSubview:scanButton];
    
    //时间
    UILabel *dtTitle = [ShareInstances addSubTitleLabel:@"库存盘点日期" withFrame:CGRectMake(MARGIN_NARROW, skuView.bottom + MARGIN_NARROW, self.width, TEXTSIZE_SUBTITLE) withSuperView:self];
    
    UIView *dtView = [[UIView alloc] initWithFrame:CGRectMake(0, dtTitle.bottom + MARGIN_NARROW, self.width, 44)];
    [dtView setBackgroundColor:[UIColor whiteColor]];
    [ShareInstances addGoIndicateOnView:dtView];
    [self addSubview:dtView];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    selectedDate = [NSDate date];
    dtLabel = [ShareInstances addLabel:[dateFormatter stringFromDate:selectedDate] withFrame:CGRectMake(MARGIN_NARROW, (44 - TEXTSIZE_BIG) / 2, dtView.width - 44 - MARGIN_NARROW, TEXTSIZE_BIG) withSuperView:dtView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    [dtView addSubview:dtLabel];
    UITapGestureRecognizer *dtTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnEditEntryDate)];
    [dtView addGestureRecognizer:dtTapGR];
    
    //库存量
    UILabel *countTitle = [ShareInstances addSubTitleLabel:@"库存数量" withFrame:CGRectMake(MARGIN_NARROW, dtView.bottom + MARGIN_NARROW, self.width, TEXTSIZE_SUBTITLE) withSuperView:self];
    
    UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(0, countTitle.bottom, self.width, 100)];
    [ShareInstances addTopBottomBorderOnView:countView];
    [countView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:countView];
    
    
}

- (void)scanBarcode{
    BarcodeScanViewController *barcodeScanVC = [[BarcodeScanViewController alloc] init];
    
    [self.rootViewNavController pushViewController:barcodeScanVC animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SKUScaned:) name:KNOTIFICATION_SKUSCANED object:nil];
    
}

- (void)SKUScaned:(NSNotification *)notification{
    NSString *barcode = [notification.userInfo objectForKey:@"barcode"];
    [self QuerySKUByBarcode:barcode];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_SKUSCANED object:nil];
}

- (void)QuerySKUByBarcode:(NSString *)barcode{
    [SVProgressHUD showWithStatus:@"正在查询SKU"];
    AVQuery *query = [SKU query];
    [query whereKey:@"commodityCode" equalTo:barcode];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                SKU *sku = [objects objectAtIndex:0];
                [hintLabel removeFromSuperview];
                [skuNameLable setText:sku.skuName];
                [SVProgressHUD showWithStatus:@"正在获取SKU缩略图"];
                [sku.image getThumbnail:YES width:180 height:180 withBlock:^(UIImage *image, NSError *error) {
                    if (!error) {
                        [SVProgressHUD dismiss];
                        [skuImage setImage:image];
                    } else{
                        [SVProgressHUD showErrorWithStatus:@"缩略图获取失败" duration:2];
                    }
                }];
            } else{
                [SVProgressHUD showErrorWithStatus:@"该商品不在系统管理范围内" duration:2];
            }
        } else{
            [SVProgressHUD showErrorWithStatus:@"网络故障，SKU查询失败" duration:2];
        }
    }];
}

-(void)OnEditEntryDate{
    CustomDatePickerView *customDatePickerView = [[CustomDatePickerView alloc] initWithFrame:self.frame withDefaultDate:selectedDate];
    customDatePickerView.delegate = self;
    [self addSubview:customDatePickerView];
}

- (void)dateChanged:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    selectedDate = date;
    [dtLabel setText:[dateFormatter stringFromDate:selectedDate]];
}



@end
