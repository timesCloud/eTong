//
//  WatchedStadiumTableViewCell.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stadium.h"

@interface WatchedStadiumTableViewCell : UITableViewCell

- (void)setStadium:(Stadium *)stadium;
+ (CGFloat)cellHeight;

@end
