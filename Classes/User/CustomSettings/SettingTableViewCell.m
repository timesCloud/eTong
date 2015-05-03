//
//  SettingTableViewCell.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "ShareInstances.h"

@interface SettingTableViewCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *headPortrait;

@end

@implementation SettingTableViewCell

- (instancetype)init{
    self = [super init];
    [self setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.width, 44)];
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_bgView];
    
    _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 90, 14)];
    [_keyLabel setFont:[UIFont systemFontOfSize:14]];
    [_keyLabel setTextColor:NORMAL_TEXT_COLOR];
    [_keyLabel setTextAlignment:NSTextAlignmentLeft];
    [_bgView addSubview:_keyLabel];
    
    return self;
}

- (void)setKey:(NSString *)key withValue:(NSString *)value{
    [_keyLabel setText:key];
    
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_keyLabel.right + 10, 15, 156, 14)];
    [_valueLabel setFont:[UIFont systemFontOfSize:14]];
    [_valueLabel setTextColor:LINK_TEXT_COLOR];
    [_valueLabel setTextAlignment:NSTextAlignmentRight];
    [_valueLabel setText:value];
    [_bgView addSubview:_valueLabel];
    
    [ShareInstances addTopBottomBorderOnView:_bgView];
}

- (void)setKey:(NSString *)key withImage:(UIImage *)image{
    [_keyLabel setText:key];
    
    _headPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(216, 5, 60, 60)];
    [_headPortrait setImage:image];
    [_headPortrait setContentMode:UIViewContentModeCenter];
    [_bgView addSubview:_headPortrait];
    
    [_bgView setHeight:70];
    [ShareInstances addTopBottomBorderOnView:_bgView];
    [_keyLabel setY:23];
}

@end
