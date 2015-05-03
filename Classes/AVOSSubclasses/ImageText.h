//
//  ImageText.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/26.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface ImageText : AVObject<AVSubclassing>

@property (nonatomic, strong) AVFile *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *order;

@end
