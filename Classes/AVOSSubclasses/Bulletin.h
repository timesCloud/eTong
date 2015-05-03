//
//  Bulletin.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class Stadium;
@interface Bulletin : AVObject<AVSubclassing>

@property (nonatomic, strong) Stadium *stadium;
@property (nonatomic, strong) NSDate *timeInForce;
@property (nonatomic, strong) NSDate *timeToFailure;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) AVUser *user;

@end
