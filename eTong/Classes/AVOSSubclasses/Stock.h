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
#import "Purchases.h"

@interface Stock : AVObject<AVSubclassing>

@property (nonatomic, weak) SKU *sku;
@property (nonatomic, weak) TerminalStore *store;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, strong) NSNumber *updateFrom;//1表示盘点，2表示进货，3表示销售
//@property (nonatomic, weak) Purchases *lastPurchase;
@property (nonatomic, strong) NSNumber *stockRate;

@end
