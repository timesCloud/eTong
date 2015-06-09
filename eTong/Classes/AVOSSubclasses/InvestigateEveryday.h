//
//  InvestigateEveryday.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class Brand;
@class TerminalStore;
@class Promotion;

@interface InvestigateEveryday : AVObject<AVSubclassing>

@property (nonatomic, weak) Brand *brand;
@property (nonatomic, weak) TerminalStore *store;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *satisfaction;
@property (nonatomic, strong) AVFile *displaySurfaceImage1;
@property (nonatomic, strong) AVFile *displaySurfaceImage2;
@property (nonatomic, strong) AVFile *displaySurfaceImage3;
@property (nonatomic, weak) Promotion *promotion;

@end
