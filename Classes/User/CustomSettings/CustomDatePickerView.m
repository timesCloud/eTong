//
//  CustomDatePickerView.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/1.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "CustomDatePickerView.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "ShareInstances.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"

@implementation CustomDatePickerView{
    NSDate *originDate;
    UIDatePicker *datePicker;
}

- (instancetype)initWithFrame:(CGRect)frame withDefaultDate:(NSDate *)date {
    self = [super initWithFrame:frame];
    
    originDate = date;
    
    [self setBackgroundColor:[UIColor clearColor]];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.height - 216, self.width, 216)];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:date animated:YES];
    [self addSubview:datePicker];
    
    UIView *operView = [[UIView alloc] initWithFrame:CGRectMake(0, datePicker.y - 44, self.width, 44)];
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
}

- (void)doBack:(id)sender {
    [self removeFromSuperview];
}

- (void)doRightButtonClick:(id)sender {
    NSDate *curDate = datePicker.date;
    if (![curDate isEqualToDate:originDate]) {
        AVUser *curUser = [AVUser currentUser];
        [curUser setObject:curDate forKey:@"birthday"];
        [SVProgressHUD showWithStatus:@"正在更新生日"];
        [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if ([_delegate respondsToSelector:@selector(dateChanged)]) {
                    [_delegate dateChanged];
                }
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:@"更新失败" duration:2];
            }
        }];
    }
    [self removeFromSuperview];
}

@end
