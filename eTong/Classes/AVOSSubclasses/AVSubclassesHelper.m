//
//  AVSubclassesHelper.m
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "AVSubclassesHelper.h"
#import "SKU.h"
#import "Brand.h"
#import "PackingSpecification.h"
#import "TerminalStore.h"
#import "MarketingChannel.h"
#import "Stock.h"
#import "Purchases.h"
#import "Delivery.h"
#import "Promotion.h"
#import "InvestigateEveryday.h"
#import "ImageText.h"
#import "Article.h"
#import "Gift.h"
#import "FinalDealer.h"
#import "Replenishment.h"

@implementation AVSubclassesHelper

+(void) RegisterSubclasses {
    [SKU registerSubclass];
    [Brand registerSubclass];
    [PackingSpecification registerSubclass];
    [TerminalStore registerSubclass];
    [MarketingChannel registerSubclass];
    [Stock registerSubclass];
    [Purchases registerSubclass];
    [Delivery registerSubclass];
    [Promotion registerSubclass];
    [InvestigateEveryday registerSubclass];
    [ImageText registerSubclass];
    [Article registerSubclass];
    [Gift registerSubclass];
    [FinalDealer registerSubclass];
    [Replenishment registerSubclass];
}

@end
