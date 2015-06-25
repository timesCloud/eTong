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
#import "wendu_yuan2.h"

@implementation SKUTableViewCell{
    UIView *bgView;
    UIImageView *skuImageView;
    UILabel *skuNameLabel;
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
    
    skuNameLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(skuImageView.right + MARGIN_NARROW, MARGIN_NARROW, size.width - 234, skuImageView.height) withSuperView:bgView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    [skuNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    skuNameLabel.numberOfLines = 0;
    
    doughnutChart = [[wendu_yuan2 alloc]initWithFrame:CGRectMake(skuNameLabel.right + MARGIN_NARROW, MARGIN_WIDE, 80, 80) withLineWidth:6.0f];
    doughnutChart.backgroundColor = [UIColor clearColor];
    [bgView addSubview:doughnutChart];
    
    [ShareInstances addLabel:@"库存率" withFrame:CGRectMake(doughnutChart.x, doughnutChart.bottom - 10, doughnutChart.width, TEXTSIZE_CONTENT) withSuperView:bgView withTextColor:LIGHT_TEXT_COLOR withAlignment:NSTextAlignmentCenter withTextSize:TEXTSIZE_CONTENT];
    
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
        }
    }];
}

@end
