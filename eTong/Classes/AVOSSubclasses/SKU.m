//
//  SKU.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SKU.h"

@implementation SKU

@dynamic skuName, image, commodityCode, brand, packingSpecification;

+ (NSString *)parseClassName {
    return @"SKU";
}

@end
