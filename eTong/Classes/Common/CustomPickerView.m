//
//  CustomPickerView.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "CustomPickerView.h"
#import "UIView+XD.h"
#import "ShareInstances.h"
#import "Defines.h"

@interface CustomPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation CustomPickerView{
    NSInteger defaultSelectedIndex, selectedIndex;
    NSArray *options;
    UIPickerView *pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame withOptionArray:(NSArray *)optionArrays withDefaultIndex:(NSInteger)index{
    self = [super initWithFrame:frame];
    
    defaultSelectedIndex = index;
    selectedIndex = index;
    self->options = optionArrays;
    
    [self setBackgroundColor:[UIColor clearColor]];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.height - 216, self.width, 216)];
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self addSubview:pickerView];
    
    UIView *operView = [[UIView alloc] initWithFrame:CGRectMake(0, pickerView.y - 44, self.width, 44)];
    [operView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:operView];
    [ShareInstances addTopBottomBorderOnView:operView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVIGATION_BUTTON_RESPONSE_WIDTH, 44)];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentMode:UIViewContentModeLeft];
    [operView addSubview:backButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - NAVIGATION_BUTTON_RESPONSE_WIDTH, 0, NAVIGATION_BUTTON_RESPONSE_WIDTH, 44)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [rightButton addTarget:self action:@selector(doRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [operView addSubview:rightButton];
    
    UIView *elseAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 216 - 44)];
    [elseAreaView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    [elseAreaView setAlpha:0.9f];
    UITapGestureRecognizer *elseAreaTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doBack:)];
    [elseAreaView addGestureRecognizer:elseAreaTapGR];
    [self addSubview:elseAreaView];
    
    return self;

    
    return self;
}

- (void)doBack:(id)sender {
    [self removeFromSuperview];
}

- (void)doRightButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(selectedIndexChanged:withTag:)])
        [_delegate selectedIndexChanged:selectedIndex withTag:self.tag];
    
    [self removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return options.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [options objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedIndex = row;
}

@end
