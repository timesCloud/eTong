//
//  Activity.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/26.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "Activity.h"

@implementation Activity

@synthesize title, startingAddress, startingPoint, targetAddress, targetPoint, isTeamActivity, price4Team, price4Adult, price4Children, startDate, endDate, weekday, startTime, endTime, imageText;

+ (NSString *)parseClassName{
    return @"Activity";
}

@end
