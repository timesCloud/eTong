//
//  NotPaidTableViewCell.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/15.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationOrder.h"

@protocol OrderTableViewCellDelegate <NSObject>

@required
- (void)PayForOrder:(ReservationOrder *)order;
- (void)CancelOrder:(ReservationOrder *)order;

@end

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic, weak) id<OrderTableViewCellDelegate> delegate;

- (void)setReservationOrder:(ReservationOrder *)order;

+ (CGFloat)cellHeight;

@end
