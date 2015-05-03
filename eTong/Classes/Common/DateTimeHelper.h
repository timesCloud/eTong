//
//  DateTimeHelper.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/25.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeHelper : NSObject

+ (NSDate *)getZeroHour:(NSDate *)date;

+ (BOOL)date:(NSDate *)date isEqualOtherDate:(NSDate *)aDate;
+ (NSDateComponents *)getDateComponents:(NSDate *)date;
+ (BOOL)isWorkingDay:(NSDate *)date;

@end
