//
//  sportField.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/20.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Stadium.h"

@interface SportField : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger order;
@property (nonatomic, strong) Stadium *stadium;
@property (nonatomic, strong) NSArray *normalPrices;
@property (nonatomic, strong) NSArray *holidayPrices;

@end
