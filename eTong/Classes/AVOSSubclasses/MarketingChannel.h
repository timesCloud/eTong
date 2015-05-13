//
//  MarketingChannel.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/10.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface MarketingChannel : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) MarketingChannel *parentChannel;

@end
