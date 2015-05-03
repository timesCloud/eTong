//
//  Stadium.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "StadiumType.h"
#import "District.h"

@interface Stadium : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) AVFile *portrait;
@property (nonatomic, strong) StadiumType *type;
@property (nonatomic, strong) NSString *telNo;
@property (nonatomic, strong) AVFile *image;
@property (nonatomic, strong) AVGeoPoint *location;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) NSInteger professionalRating;
@property (nonatomic) NSInteger userRating;
@property (nonatomic) NSInteger userRatingCount;
@property (nonatomic, strong) District *district;
@property (nonatomic, strong) AVRelation *sportsFields;
@property (nonatomic) NSInteger shopHoursBegin;
@property (nonatomic) NSInteger shopHoursEnd;
@property (nonatomic) NSInteger availableSessionCount;

@end
