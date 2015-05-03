//
//  SpecialDay.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/22.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Stadium.h"

@interface SpecialDay : AVObject<AVSubclassing>

@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) Stadium *stadium;

@end
