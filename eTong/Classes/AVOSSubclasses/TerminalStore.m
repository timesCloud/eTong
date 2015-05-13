//
//  TerminalStore.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/10.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStore.h"

@implementation TerminalStore

@synthesize shopKeeper, storeName, address, location, telNo, businessLicenseNo, email, channel, shopFrontPhoto, sku;

+(NSString *)parseClassName{
    return @"TerminalStore";
}

@end
