//
//  Purchases.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "SKU.h"
#import "Stock.h"
#import "TerminalStore.h"
#import "Delivery.h"

@class Stock;

@interface Purchases : AVObject<AVSubclassing>

@property (nonatomic, weak) SKU *sku;
@property (nonatomic, weak) TerminalStore *store;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *stockCountBeforePurchase;
@property (nonatomic, weak) Stock *stockBeforePurchase;
@property (nonatomic, weak) Stock *stockAfterPurchase;

@end
