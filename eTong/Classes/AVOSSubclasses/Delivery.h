//
//  Delivery.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "SKU.h"
#import "TerminalStore.h"

@interface Delivery : AVObject<AVSubclassing>

@property (nonatomic, weak) SKU *sku;
@property (nonatomic, weak) AVObject *distributor;
@property (nonatomic, weak) TerminalStore *store;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic) BOOL isSynced;//是否已经被终端店同步为进货记录

@end
