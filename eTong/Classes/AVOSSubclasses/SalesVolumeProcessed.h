//
//  SalesVolumeProcessed.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "SKU.h"
#import "TerminalStore.h"
#import "SalesVolumeOrigin.h"

@interface SalesVolumeProcessed : AVObject<AVSubclassing>

@property (nonatomic, weak) SKU *sku;
@property (nonatomic, weak) TerminalStore *store;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, weak) SalesVolumeOrigin *originRecord;

@end
