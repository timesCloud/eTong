//
//  InvestigateEveryday.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "InvestigateEveryday.h"
#import "Brand.h"
#import "TerminalStore.h"
#import "Promotion.h"

@implementation InvestigateEveryday

@dynamic brand, store, date, satisfaction, displaySurfaceImage1, displaySurfaceImage2, displaySurfaceImage3, promotion;

+(NSString *)parseClassName{
    return @"InvestigateEveryday";
}

@end
