//
//  Activity.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/26.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Activity : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *startingAddress;
@property (nonatomic, strong) AVGeoPoint *startingPoint;
@property (nonatomic, strong) NSString *targetAddress;
@property (nonatomic, strong) NSString *targetPoint;
@property (nonatomic) BOOL isTeamActivity;
@property (nonatomic, strong) NSNumber *price4Team;
@property (nonatomic, strong) NSNumber *price4Adult;
@property (nonatomic, strong) NSNumber *price4Children;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSArray *weekday;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) AVRelation *imageText;

@end
