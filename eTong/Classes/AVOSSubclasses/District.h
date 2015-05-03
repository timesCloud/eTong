//
//  District.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/5.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface District : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger order;

@end
