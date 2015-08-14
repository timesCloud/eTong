//
//  Replenishment.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/26.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "Replenishment.h"
#import "SKU.h"
#import "FinalDealer.h"
#import "TerminalStore.h"

@implementation Replenishment
@dynamic sku, store, dealer, count, date;

+(NSString *)parseClassName{
    return @"Replenishment";
}

@end
