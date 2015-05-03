//
//  ReservationSuborder.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/22.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Stadium.h"
#import "sportField.h"

@interface ReservationSuborder : AVObject<AVSubclassing>

@property (nonatomic, strong) NSDate *generateDateTime;
@property (nonatomic, strong) NSDate *payDateTime;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger time;
@property (nonatomic, strong) Stadium *stadium;
@property (nonatomic, strong) SportField *sportField;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) AVUser *user;
@property (nonatomic) BOOL isPaid;

@end
