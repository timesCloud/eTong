//
//  Purchases.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "Purchases.h"

@implementation Purchases

@dynamic sku, store, date, count, stockCountBeforePurchase, stockAfterPurchase, stockBeforePurchase;

+(NSString *)parseClassName{
    return @"Purchases";
}

@end
