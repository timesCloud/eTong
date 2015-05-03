//
//  selectableTableViewCell.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/2.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SelectableTableViewCell.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "ShareInstances.h"

@interface SelectableTableViewCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightIcon;

@end

@implementation SelectableTableViewCell{
    BOOL objectSelected;
    NSInteger objectIndex;
}

- (instancetype)init{
    self = [super init];
    
    [self setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.width - 10, 44)];
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [ShareInstances addAllBorderOnView:_bgView];
    [self addSubview:_bgView];
    UITapGestureRecognizer *bgViewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewOnTouch)];
    [_bgView addGestureRecognizer:bgViewTapGR];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 260, 14)];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_titleLabel setTextColor:NORMAL_TEXT_COLOR];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_bgView addSubview:_titleLabel];
    
    _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_bgView.width - 36, 14, 16, 16)];
    [_rightIcon setContentMode:UIViewContentModeCenter];
    [_rightIcon setImage:[UIImage imageNamed:@"right.png"]];
    
    return self;
}

- (void)setTitle:(NSString *)title withObjectIndex:(NSInteger)index selected:(BOOL)selected{
    objectSelected = selected;
    objectIndex = index;
    [_titleLabel setText:title];
    
    if (selected) {
        [_bgView addSubview:_rightIcon];
        [_titleLabel setTextColor:MAIN_COLOR];
    } else {
        [_rightIcon removeFromSuperview];
        [_titleLabel setTextColor:NORMAL_TEXT_COLOR];
    }
}

- (void)bgViewOnTouch{
    objectSelected = !objectSelected;
    if (objectSelected) {
        [_bgView addSubview:_rightIcon];
        [_titleLabel setTextColor:MAIN_COLOR];
    } else {
        [_rightIcon removeFromSuperview];
        [_titleLabel setTextColor:NORMAL_TEXT_COLOR];
    }
    
    if ([_delegate respondsToSelector:@selector(cellSelectionChanged:withObjectIndex:)]) {
        [_delegate cellSelectionChanged:objectSelected withObjectIndex:objectIndex];
    }
}

@end
