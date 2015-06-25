//
//  HomeViewCell.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>

#define kArticleCellHeight 80

@class Article;

@interface NewsViewCell : UITableViewCell

- (void)setArticle:(Article *)article;

@property (retain, nonatomic) IBOutlet UIImageView *headerImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *summaryLabel;

@end
