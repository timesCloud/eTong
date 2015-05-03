//
//  SorryView.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/20.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SorryView.h"
#import "UIView+XD.h"
#import "Defines.h"

@implementation SorryView

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeViewController = controller;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 200)];
    [imageView setImage:[UIImage imageNamed:@"sorry.jpg"]];
    [imageView setContentMode:UIViewContentModeCenter];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom, self.width, 20)];
    [label setText:@"暂无最新内容"];
    [label setTextColor:NORMAL_TEXT_COLOR];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
}

@end
