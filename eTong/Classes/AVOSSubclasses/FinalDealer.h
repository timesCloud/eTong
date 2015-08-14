//
//  FinalDealer.h
//  eTong
//
//  Created by TsaoLipeng on 15/6/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class Brand;

@interface FinalDealer : AVObject<AVSubclassing>

@property (nonatomic, strong) AVUser *manager;
@property (nonatomic, strong) Brand *brand;
@property (nonatomic, strong) AVRelation *sku;
@property (nonatomic, strong) AVRelation *terminalStores;
@property (nonatomic, strong) AVRelation *appliedStores;
@property (nonatomic, strong) NSString *dealerName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *telNo;
@property (nonatomic, strong) NSString *businessLicenseNo;

@end
