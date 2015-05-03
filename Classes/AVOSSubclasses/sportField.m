//
//  sportField.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/20.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "sportField.h"

@implementation SportField

@synthesize name, order, stadium, normalPrices, holidayPrices;

+(NSString *)parseClassName {
    return @"sportField";
}

@end
