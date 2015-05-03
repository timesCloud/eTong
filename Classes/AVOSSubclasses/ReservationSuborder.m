//
//  ReservationSuborder.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/22.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ReservationSuborder.h"

@implementation ReservationSuborder

@synthesize generateDateTime,payDateTime,description,time,stadium,sportField,user,isPaid, price;

+ (NSString *)parseClassName {
    return @"reservationSuborder";
}

@end
