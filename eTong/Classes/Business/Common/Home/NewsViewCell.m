//
//  HomeViewCell.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "NewsViewCell.h"
#import "Article.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "ShareInstances.h"

#define kImageViewAspectRatio 0.75

@implementation NewsViewCell
@synthesize titleLabel, summaryLabel, headerImageView;

- (void)setArticle:(Article *)article{
    [titleLabel setText:article.title];
    [summaryLabel setText:article.summary];
    
    [article.listImageFile getThumbnail:YES width:160 height:120 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [headerImageView setImage:image];
            
        }
    }];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_WIDE, MARGIN_WIDE, (kArticleCellHeight - MARGIN_WIDE * 2) / kImageViewAspectRatio, kArticleCellHeight - MARGIN_WIDE * 2)];
        headerImageView.layer.cornerRadius = 4.0f;
        headerImageView.layer.masksToBounds = YES;
        [self addSubview:headerImageView];
        
        CGSize size = [[UIScreen mainScreen] applicationFrame].size;
        titleLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(headerImageView.right + MARGIN_WIDE, headerImageView.y, size.width - headerImageView.right - MARGIN_WIDE - 44, TEXTSIZE_BIG) withSuperView:self withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
        summaryLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(titleLabel.x, titleLabel.bottom + MARGIN_WIDE, titleLabel.width, headerImageView.height - titleLabel.bottom) withSuperView:self withTextColor:LIGHT_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_SUBTITLE];
        [summaryLabel setLineBreakMode:NSLineBreakByWordWrapping];
        summaryLabel.numberOfLines = 0;
        
        [ShareInstances addGoIndicateOnView:self withImageFrame:CGRectMake(size.width - 44, (kArticleCellHeight - 44) / 2, 44, 44)];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.headerImageView.layer.cornerRadius = 5;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
