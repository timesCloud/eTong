//
//  MarketingChannel.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/10.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "MarketingChannel.h"

@implementation MarketingChannel

@synthesize channelName, order, parentChannel;

+ (NSString *)parseClassName{
    return @"MarketingChannel";
}

@end
