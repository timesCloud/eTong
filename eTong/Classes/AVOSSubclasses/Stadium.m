//
//  Stadium.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "Stadium.h"

@implementation Stadium

@synthesize description, name, portrait, type, telNo, image, location, address, professionalRating, userRating, userRatingCount, sportsFields, shopHoursBegin, shopHoursEnd, availableSessionCount, district;

+ (NSString *)parseClassName {
    return @"stadium";
}

@end
