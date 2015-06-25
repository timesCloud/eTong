//
//  GiftTableViewCell.h
//  eTong
//
//  Created by TsaoLipeng on 15/6/21.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGiftCellHeight 100
@class Gift;

@interface GiftTableViewCell : UITableViewCell

- (void)setArticle:(Gift *)gift;

@end
