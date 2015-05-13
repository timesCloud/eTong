//
//  SKU.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Brand.h"
#import "PackingSpecification.h"

@interface SKU : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *skuName;
@property (nonatomic, strong) AVFile *image;
@property (nonatomic, strong) NSString *commodityCode;
@property (nonatomic, weak) Brand *brand;
@property (nonatomic, strong) AVRelation *packingSpecification;

@end
