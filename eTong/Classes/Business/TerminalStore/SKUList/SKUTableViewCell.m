//
//  SKUTableViewCell.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SKUTableViewCell.h"
#import "ShareInstances.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "SKU.h"
#import "Stock.h"
#import "Replenishment.h"
#import "wendu_yuan2.h"
#import "DateTimeHelper.h"

@implementation SKUTableViewCell{
    UIView *bgView;
    UIImageView *skuImageView;
    UILabel *skuNameLabel, *stockRateLabel, *purchaseInfoLabel;
    wendu_yuan2 * doughnutChart;
    
    UIView *buttonView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    CGRect frame = CGRectMake(0, MARGIN_NARROW, size.width, 100);
    bgView = [[UIView alloc] initWithFrame:frame];
    [ShareInstances addTopBottomBorderOnView:bgView];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    [ShareInstances addGoIndicateOnView:bgView];
    
    skuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    [skuImageView setContentMode:UIViewContentModeCenter];
    [bgView addSubview:skuImageView];
    
    skuNameLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(skuImageView.right + MARGIN_NARROW, MARGIN_WIDE, size.width - 214, skuImageView.height - TEXTSIZE_TITLE - MARGIN_WIDE) withSuperView:bgView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    [skuNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    skuNameLabel.numberOfLines = 0;
    
    purchaseInfoLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(skuNameLabel.x, skuImageView.bottom - TEXTSIZE_TITLE - MARGIN_WIDE, skuNameLabel.width, TEXTSIZE_TITLE) withSuperView:bgView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_TITLE];
    
    doughnutChart = [[wendu_yuan2 alloc]initWithFrame:CGRectMake(size.width - 44 - 70, MARGIN_WIDE, 70, 70) withLineWidth:6.0f];
    doughnutChart.backgroundColor = [UIColor clearColor];
    [bgView addSubview:doughnutChart];
    
    stockRateLabel = [ShareInstances addLabel:@"无库存数据" withFrame:CGRectMake(doughnutChart.x, doughnutChart.bottom - 5, size.width - doughnutChart.x, TEXTSIZE_CONTENT) withSuperView:bgView withTextColor:LIGHT_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_CONTENT];
    
    return self;
}

-(void)setSKU:(SKU *)sku{
    [sku.image getThumbnail:YES width:180 height:180 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [skuImageView setImage:image];
        }
    }];
    [skuNameLabel setText:sku.skuName];
    
    [doughnutChart setZ:0];
    AVQuery *query = [Stock query];
    [query addDescendingOrder:@"date"];
    [query addAscendingOrder:@"createAt"];
    [query whereKey:@"sku" equalTo:sku];
    if(_curTerminalStore == nil)
        _curTerminalStore = [ShareInstances getCurrentTerminalStore];
    [query whereKey:@"store" equalTo:_curTerminalStore];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && [objects count] > 0) {
            Stock *stock = [objects objectAtIndex:0];
            [doughnutChart setZ:[stock.stockRate floatValue]];
            [stockRateLabel setText:[NSString stringWithFormat:@"剩余库存%@", stock.stock]];
        }
    }];
    
    if ([[[AVUser currentUser] objectForKey:@"role"] integerValue] == 2) {//当前用户为终极经销商
        AVQuery *query2 = [Replenishment query];
        [query2 orderByDescending:@"date"];
        [query2 whereKey:@"sku" equalTo:sku];
        [query2 whereKey:@"store" equalTo:_curTerminalStore];
        [query2 whereKey:@"dealer" equalTo:[ShareInstances getCurrentFinalDealer]];
        [query2 setLimit:1];
        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count > 0) {
                Replenishment *r = [objects objectAtIndex:0];
                NSInteger dif = [DateTimeHelper differFromDate:r.date toDate:[NSDate date]];
                if (dif == 0) {
                    [purchaseInfoLabel setText:@"今日已补货"];
                    [purchaseInfoLabel setTextColor:MAIN_COLOR];
                }else{
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MM月dd日补货"];
                    [purchaseInfoLabel setText:[formatter stringFromDate:r.date]];
                    if (dif <= 3) [purchaseInfoLabel setTextColor:[UIColor greenColor]];
                    else if (dif <= 7) [purchaseInfoLabel setTextColor:[UIColor orangeColor]];
                    else [purchaseInfoLabel setTextColor:[UIColor redColor]];
                }
            }else{
                [purchaseInfoLabel setText:@"没有补货记录"];
                [purchaseInfoLabel setTextColor:LIGHT_TEXT_COLOR];
            }
        }];
    }
}

@end
