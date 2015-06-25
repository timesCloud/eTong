//
//  FinalDealer.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "FinalDealer.h"
#import "Brand.h"

@implementation FinalDealer
@dynamic manager, brand, sku, terminalStores, dealerName, address, telNo, businessLicenseNo;

+(NSString *)parseClassName{
    return @"FinalDealer";
}

@end
