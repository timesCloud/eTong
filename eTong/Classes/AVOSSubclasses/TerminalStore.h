//
//  TerminalStore.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/10.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "MarketingChannel.h"
#import "SKU.h"

@interface TerminalStore : AVObject<AVSubclassing>

@property (nonatomic, weak) AVUser *shopKeeper;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) AVGeoPoint *location;
@property (nonatomic, strong) NSString *telNo;
@property (nonatomic, strong) NSString *businessLicenseNo;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) MarketingChannel *channel;
@property (nonatomic, strong) AVFile *shopFrontPhoto;
@property (nonatomic, strong) AVRelation *sku;

@end
