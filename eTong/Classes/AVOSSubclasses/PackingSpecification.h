//
//  PackingSpecification.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface PackingSpecification : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *packingName;//包装名，如“24听整箱”
@property (nonatomic, strong) NSString *unit;//包装单位，如“箱”、“件”
@property (nonatomic, strong) AVFile *image;//包装图片
@property (nonatomic, strong) NSNumber *containsCount;//包装中所含单品单件商品的数量
@property (nonatomic, strong) NSString *unitInBulk;//单件商品的单位，如“听”、“瓶”、“桶”

@end
