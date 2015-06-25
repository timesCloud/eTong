//
//  ImageText.h
//  eTong
//
//  Created by TsaoLipeng on 15/6/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface ImageText : AVObject<AVSubclassing>

@property (nonatomic, strong) AVFile *image;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *order;

@end
