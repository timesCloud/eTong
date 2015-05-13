//
//  Stock.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "SKU.h"
#import "TerminalStore.h"
#import "SalesVolumeOrigin.h"
#import "Purchases.h"

@interface Stock : AVObject<AVSubclassing>

@property (nonatomic, weak) SKU *sku;
@property (nonatomic, weak) TerminalStore *store;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, strong) NSNumber *updateFrom;//1表示进货，2表示销售，3表示盘点
@property (nonatomic, weak) SalesVolumeOrigin *salesRecord;
@property (nonatomic, weak) AVObject *purchasesRecord;

@end
