//
//  Promotion.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Promotion : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString* promotionName;
@property (nonatomic, strong) NSNumber *order;

@end
