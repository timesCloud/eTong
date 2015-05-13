//
//  SalesVolumeOrigin.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "SKU.h"
#import "TerminalStore.h"

@interface SalesVolumeOrigin : AVObject<AVSubclassing>

@property (nonatomic, weak) SKU *sku;
@property (nonatomic, weak) TerminalStore *store;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSDate *date;

@end
