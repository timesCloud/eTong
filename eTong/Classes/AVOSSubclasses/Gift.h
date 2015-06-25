//
//  Gift.h
//  eTong
//
//  Created by TsaoLipeng on 15/6/21.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Gift : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *giftName;
@property (nonatomic, strong) AVFile *image;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSNumber *point;
@property (nonatomic, strong) AVRelation *detail;

@end
