//
//  Stock.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "Stock.h"

@implementation Stock

@synthesize sku, store, date, stock, salesRecord, purchasesRecord;

+(NSString *)parseClassName{
    return @"Stock";
}

@end
