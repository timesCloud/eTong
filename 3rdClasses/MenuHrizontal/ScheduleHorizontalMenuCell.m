//
//  ScheduleHorizontalMenuCell.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/21.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ScheduleHorizontalMenuCell.h"
#import<QuartzCore/QuartzCore.h>
#import "UIView+XD.h"
#import "Stadium.h"
#import "ReservationSuborder.h"
#import "DateTimeHelper.h"
#import "SVProgressHUD.h"

@implementation ScheduleHorizontalMenuCell {
    UILabel *dateLabel;
    UILabel *remainCountLabel;
}

- (instancetype)initWithOriginX:(CGFloat)x withOriginY:(CGFloat)y {
    self = [super initWithFrame:CGRectMake(x, y, kScheduleHorizontalMenuCellWidth, kScheduleHorizontalMenuCellHeight)];
    [self setBackgroundColor:[UIColor whiteColor]];
    //设置圆角边框
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    //设置边框及边框颜色
    self.layer.borderWidth = 0;
    //self.layer.borderColor =[ [UIColor lightGrayColor] CGColor];
    return self;
}

- (void)initializeWithStadium:(Stadium *)stadium withDate:(NSDate *)date {
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, kScheduleHorizontalMenuCellWidth, 15)];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setTextColor:[UIColor grayColor]];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:dateLabel];
    
    remainCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateLabel.frame.origin.y + dateLabel.height + 4, kScheduleHorizontalMenuCellWidth, 15)];
    [remainCountLabel setTextColor:[UIColor lightGrayColor]];
    [remainCountLabel setFont:[UIFont systemFontOfSize:12]];
    [remainCountLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *reservationButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, remainCountLabel.frame.origin.y + remainCountLabel.height + 9, 78, 24)];
    [reservationButtonLabel setBackgroundColor:[UIColor orangeColor]];
    [reservationButtonLabel setTextColor:[UIColor whiteColor]];
    [reservationButtonLabel setFont:[UIFont systemFontOfSize:12]];
    [reservationButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [reservationButtonLabel setText:@"预订"];
    reservationButtonLabel.layer.cornerRadius = 4;
    reservationButtonLabel.layer.masksToBounds = YES;
    [self addSubview:reservationButtonLabel];
    
    //[self updateCellWithStadium:stadium withDate:date];
}

- (void)updateCellWithStadium:(Stadium *)stadium withDate:(NSDate *)date {
    date = [DateTimeHelper getZeroHour:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (![DateTimeHelper date:[NSDate date] isEqualOtherDate:[DateTimeHelper getZeroHour:date]]) {
        [dateFormatter setDateFormat:@"EEE/M.d"];
    } else {
        [dateFormatter setDateFormat:@"今天/M.d"];
    }
    [dateLabel setText:[dateFormatter stringFromDate:date]];
    
    [SVProgressHUD showWithStatus:@"正在更新场地空位"];
    AVQuery *query = [ReservationSuborder query];
    [query whereKey:@"stadium" equalTo:stadium];
    [query whereKey:@"date" greaterThanOrEqualTo:date];
    [query whereKey:@"date" lessThan:[date dateByAddingTimeInterval:1]];
    [query whereKey:@"generateDateTime" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60 * 15]];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (!error) {
            [remainCountLabel setText:[NSString stringWithFormat:@"空场 %ld/%ld", stadium.availableSessionCount - number, stadium.availableSessionCount]];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络故障，场地空位查询失败" duration:2];
        }
    }];
    [self addSubview:remainCountLabel];
}

@end
