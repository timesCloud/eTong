//
//  GiftTableViewCell.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/21.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "GiftTableViewCell.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "UIView+XD.h"
#import "Gift.h"

@interface GiftTableViewCell()

@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (retain, nonatomic) UILabel *summaryLabel;

@end

@implementation GiftTableViewCell
@synthesize titleLabel, priceLabel, summaryLabel, headerImageView;

- (void)setArticle:(Gift *)gift{
    [titleLabel setText:gift.giftName];
    [priceLabel setText:[NSString stringWithFormat:@"兑换价格：%ld积分", (long)[gift.point integerValue]]];
    [summaryLabel setText:gift.summary];
    
    CGFloat width = (kGiftCellHeight - MARGIN_WIDE * 2) * 2;
    [gift.image getThumbnail:YES width:width height:width withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [headerImageView setImage:image];
            
        }
    }];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_WIDE, MARGIN_WIDE, kGiftCellHeight - MARGIN_WIDE * 2, kGiftCellHeight - MARGIN_WIDE * 2)];
        headerImageView.layer.cornerRadius = 4.0f;
        headerImageView.layer.masksToBounds = YES;
        [self addSubview:headerImageView];
        
        CGSize size = [[UIScreen mainScreen] applicationFrame].size;
        titleLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(headerImageView.right + MARGIN_WIDE, headerImageView.y, size.width - headerImageView.right - MARGIN_WIDE - 44, TEXTSIZE_BIG) withSuperView:self withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
        priceLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(titleLabel.x, titleLabel.bottom + MARGIN_NARROW, titleLabel.width, TEXTSIZE_SUBTITLE) withSuperView:self withTextColor:[UIColor orangeColor] withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_SUBTITLE];
        summaryLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(titleLabel.x, priceLabel.bottom + MARGIN_NARROW, titleLabel.width, headerImageView.height - priceLabel.bottom) withSuperView:self withTextColor:LIGHT_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_SUBTITLE];
        [summaryLabel setLineBreakMode:NSLineBreakByWordWrapping];
        summaryLabel.numberOfLines = 0;
        
        [ShareInstances addGoIndicateOnView:self withImageFrame:CGRectMake(size.width - 44, (kGiftCellHeight - 44) / 2, 44, 44)];
    }
    return self;
}


@end
