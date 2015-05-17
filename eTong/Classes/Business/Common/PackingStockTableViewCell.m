//
//  PackingStockTableViewCell.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "PackingStockTableViewCell.h"
#import "ShareInstances.h"
#import "Defines.h"
#import "UIView+XD.h"

@implementation PackingStockTableViewCell{
    UIImageView *packingImageView;
    UILabel *packingNameLabel;
    //UITextField *
}

-(instancetype)init{
    self = [super init];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(0, MARGIN_NARROW, self.width, 100)];
    [ShareInstances addTopBottomBorderOnView:countView];
    [countView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:countView];
    
    packingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    [packingImageView setContentMode:UIViewContentModeCenter];
    [self addSubview:packingImageView];
    
    packingNameLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(packingImageView.right + MARGIN_NARROW, MARGIN_WIDE, self.width - 100, TEXTSIZE_BIG) withSuperView:self withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    
    
    return self;
}

@end
