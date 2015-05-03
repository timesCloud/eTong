//
//  Bulletin.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "Bulletin.h"
#import "Stadium.h"

@implementation Bulletin

@synthesize timeInForce, timeToFailure, stadium, user, content;

+ (NSString *)parseClassName {
    return @"Bulletin";
}

@end
