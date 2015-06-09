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
    
    UIView *buttonView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, MARGIN_NARROW, self.width, 100)];
    [ShareInstances addTopBottomBorderOnView:bgView];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    [ShareInstances addGoIndicateOnView:bgView];
    
    skuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    [skuImageView setContentMode:UIViewContentModeCenter];
    [bgView addSubview:skuImageView];
    
    skuNameLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(skuImageView.right + MARGIN_NARROW, MARGIN_WIDE, self.width - 100, TEXTSIZE_BIG) withSuperView:bgView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    return self;
}

-(void)setSKU:(SKU *)sku{
    [sku.image getThumbnail:YES width:180 height:180 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [skuImageView setImage:image];
        }
    }];
    [skuNameLabel setText:sku.skuName];
}

@end
