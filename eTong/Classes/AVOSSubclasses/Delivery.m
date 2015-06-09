//
//  Delivery.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "Delivery.h"

@implementation Delivery

@dynamic sku, distributor, store, date, count, isSynced;

+(NSString *)parseClassName{
    return @"Delivery";
}

@end
