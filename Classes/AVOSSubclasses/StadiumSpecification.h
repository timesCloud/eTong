//
//  StadiumSpecification.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Stadium.h"

@interface StadiumSpecification : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) AVFile *image;
@property (nonatomic, strong) Stadium *stadium;
@property (nonatomic, strong) NSNumber *order;

@end
