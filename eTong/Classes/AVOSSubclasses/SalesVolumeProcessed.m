//
//  SalesVolumeProcessed.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SalesVolumeProcessed.h"

@implementation SalesVolumeProcessed

@synthesize sku, store, date, count, originRecord;

+(NSString *)parseClassName{
    return @"SalesVolumeProcessed";
}

@end
