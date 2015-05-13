//
//  PackingSpecification.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "PackingSpecification.h"

@implementation PackingSpecification

@synthesize packingName, unit, image, containsCount, unitInBulk;

+ (NSString *)parseClassName{
    return @"PackingSpecification";
}

@end
