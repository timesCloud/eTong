//
//  ScheduleHorizontalMenuCell.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/21.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stadium.h"

#define kScheduleHorizontalMenuCellWidth 88
#define kScheduleHorizontalMenuCellHeight 80

@interface ScheduleHorizontalMenuCell : UIView

- (instancetype)initWithOriginX:(CGFloat)x withOriginY:(CGFloat)y;

- (void)initializeWithStadium:(Stadium *)stadium withDate:(NSDate *)date;

- (void)updateCellWithStadium:(Stadium *)stadium withDate:(NSDate *)date;

@end
