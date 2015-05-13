//
//  SalesVolumeOrigin.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SalesVolumeOrigin.h"

@implementation SalesVolumeOrigin

@synthesize sku, store, date, count;

+(NSString *)parseClassName{
    return @"SalesVolumnOrigin";
}

@end
