//
//  Replenishment.h
//  eTong
//
//  Created by TsaoLipeng on 15/6/26.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class SKU;
@class TerminalStore;
@class FinalDealer;

@interface Replenishment : AVObject<AVSubclassing>

@property (nonatomic, strong) SKU *sku;
@property (nonatomic, strong) TerminalStore *store;
@property (nonatomic, strong) FinalDealer *dealer;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSDate *date;

@end
