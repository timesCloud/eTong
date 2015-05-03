//
//  DateTimeHelper.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/25.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "DateTimeHelper.h"

@implementation DateTimeHelper

+ (NSDate *)getZeroHour:(NSDate *)date {
    //NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    //[gregorian setTimeZone:gmt];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 0];
    [components setMinute:0];
    [components setSecond: 0];
    NSDate *newDate = [gregorian dateFromComponents: components];
    return newDate;
}

+ (BOOL)date:(NSDate *)date isEqualOtherDate:(NSDate *)aDate
{
    if (aDate == nil || date == nil) return NO;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate])
        return YES;
    
    return NO;
}

+ (NSDateComponents *)getDateComponents:(NSDate *)date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
//    int week = [comps weekday];
//    int year=[comps year];
//    int month = [comps month];
//    int day = [comps day];
//    //[formatter setDateStyle:NSDateFormatterMediumStyle];
//    //This sets the label with the updated time.
//    int hour = [comps hour];
//    int min = [comps minute];
//    int sec = [comps second];
}

+ (BOOL)isWorkingDay:(NSDate *)date {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    return week != 7 && week != 1;
}

@end
