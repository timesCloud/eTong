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

@implementation SKUTableViewCell{
    UIView *bgView;
    UIImageView *skuImageView;
    UILabel *skuNameLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, MARGIN_NARROW, self.width, 100)];
    [ShareInstances addTopBottomBorderOnView:bgView];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    
    skuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    [skuImageView setContentMode:UIViewContentModeCenter];
    [bgView addSubview:skuImageView];
    
    skuNameLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(skuImageView.right + MARGIN_NARROW, MARGIN_WIDE, self.width - 100, TEXTSIZE_BIG) withSuperView:bgView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    UIButton *salesEntryButton = [[UIButton alloc] init];
    salesEntryButton.centerX = self.width * 0.165f;
    salesEntryButton.y = bgView.bottom + MARGIN_WIDE;
    salesEntryButton.width = 80;
    salesEntryButton.height = 32;
    [salesEntryButton setTitle:@"销售录入" forState:UIControlStateNormal];
    [self addSubview:salesEntryButton];
    
    UIButton *purchasesButton = [[UIButton alloc] init];
    purchasesButton.centerX = self.width * 0.5f;
    purchasesButton.y = salesEntryButton.y;
    purchasesButton.width = 80;
    purchasesButton.height = 32;
    [purchasesButton setTitle:@"进货录入" forState:UIControlStateNormal];
    [self addSubview:purchasesButton];
    
    UIButton *stockCheckButton = [[UIButton alloc] init];
    stockCheckButton.centerX = self.width * 0.835f;
    stockCheckButton.y = salesEntryButton.y;
    stockCheckButton.width = 80;
    stockCheckButton.height = 32;
    [stockCheckButton setTitle:@"库存盘点" forState:UIControlStateNormal];
    [self addSubview:stockCheckButton];
    
    return self;
}

-(void)setSKU:(SKU *)sku WithHighlighted:(BOOL)highlighted{
    [sku.image getThumbnail:YES width:180 height:180 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [skuImageView setImage:image];
        }
    }];
    [skuNameLabel setText:sku.skuName];
    
    if (highlighted) {
        [bgView setBackgroundColor:[UIColor blueColor]];
    }
}

@end
