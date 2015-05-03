//
//  CustomAnnotationView.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/6.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "CustomAnnotationView.h"
#import "UIView+XD.h"
#import "Defines.h"

#define lMargin 5
#define lPortraitSize 64
#define lFontSize 12

@implementation CustomAnnotationView {
    AVFile *headPortrait;
    NSString *title;
    NSString *subTitle;
}

- (instancetype)initWithProtrait:(AVFile *)image withTitle:(NSString *)t withSubTitle:(NSString *)st{
    self = [super init];
    headPortrait = image;
    title = t;
    subTitle = st;
    [self initialize];
    return self;
}

- (void)initialize {
    UIImageView *headPortraitView = [[UIImageView alloc] init];
    [headPortraitView setFrame:CGRectMake(lMargin, lMargin, lPortraitSize, lPortraitSize)];
    [headPortraitView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:headPortraitView];
    [headPortrait getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error && data != nil) {
            [headPortraitView setImage:[UIImage imageWithData:data]];
        }
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(headPortraitView.right + lMargin, lMargin, lFontSize * [title length], lFontSize)];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [titleLabel setTextColor:NORMAL_TEXT_COLOR];
    [self addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(headPortraitView.right + lMargin, titleLabel.bottom + lMargin, lFontSize * [subTitle length], lFontSize)];
    [subTitleLabel setText:title];
    [subTitleLabel setFont:[UIFont systemFontOfSize:12]];
    [subTitleLabel setTextColor:NORMAL_TEXT_COLOR];
    [self addSubview:subTitleLabel];
}


@end
