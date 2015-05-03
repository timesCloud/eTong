//
//  SexSelectionViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/31.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SexSelectionViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"

@interface SexSelectionViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UILabel *maleLabel;
@property (nonatomic, strong) UILabel *femaleLabel;
@property (nonatomic, strong) UIView *maleView;
@property (nonatomic, strong) UIView *femaleView;
@property (nonatomic, strong) UIImageView *rightIcon;

@end

@implementation SexSelectionViewController{
    NSInteger originSex, curSex;
}

- (instancetype)init{
    self = [super init];
    [self initialize];
    return self;
}

- (void)initialize{
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    _navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"选择性别" withRightButtonTitle:@"确定"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    _maleView = [[UIView alloc] initWithFrame:CGRectMake(10, _navigationBar.bottom + 10, self.view.width - 20, 44)];
    [_maleView setBackgroundColor:[UIColor whiteColor]];
    _maleView.tag = 1;
    [self.view addSubview:_maleView];
    UITapGestureRecognizer *maleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maleViewOnTouch)];
    [_maleView addGestureRecognizer:maleTapGR];
    
    _femaleView = [[UIView alloc] initWithFrame:CGRectMake(10, _maleView.bottom + 0.5f, self.view.width - 20, 44)];
    [_femaleView setBackgroundColor:[UIColor whiteColor]];
    _femaleView.tag = 2;
    [self.view addSubview:_femaleView];
    UITapGestureRecognizer *femaleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(femaleViewOnTouch)];
    [_femaleView addGestureRecognizer:femaleTapGR];
    
    _maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 50, 14)];
    [_maleLabel setFont:[UIFont systemFontOfSize:14]];
    [_maleLabel setTextColor:NORMAL_TEXT_COLOR];
    [_maleLabel setText:@"男"];
    [_maleLabel setTextAlignment:NSTextAlignmentCenter];
    [_maleView addSubview:_maleLabel];
    
    _femaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 50, 14)];
    [_femaleLabel setFont:[UIFont systemFontOfSize:14]];
    [_femaleLabel setTextColor:NORMAL_TEXT_COLOR];
    [_femaleLabel setText:@"女"];
    [_femaleLabel setTextAlignment:NSTextAlignmentCenter];
    [_femaleView addSubview:_femaleLabel];
    
    _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_maleView.width - 36, 14, 16, 16)];
    [_rightIcon setContentMode:UIViewContentModeCenter];
    [_rightIcon setImage:[UIImage imageNamed:@"right.png"]];
}

- (void)setInitSex:(NSInteger)sex{
    originSex = sex;
    curSex = sex;
    [_rightIcon removeFromSuperview];
    if (sex == 1) {
        [_maleView addSubview:_rightIcon];
    } else {
        [_femaleView addSubview:_rightIcon];
    }
}

- (void)maleViewOnTouch{
    [_rightIcon removeFromSuperview];
    curSex = 1;
    [_maleView addSubview:_rightIcon];
}

- (void)femaleViewOnTouch{
    [_rightIcon removeFromSuperview];
    curSex = 2;
    [_femaleView addSubview:_rightIcon];
}

#pragma mark NormalNavigationDelegate
- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick {
    if (originSex != curSex) {
        AVUser *curUser = [AVUser currentUser];
        [curUser setObject:[NSNumber numberWithInteger:curSex] forKey:@"sex"];
        [SVProgressHUD showWithStatus:@"正在更新性别"];
        [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if ([_delegate respondsToSelector:@selector(sexChanged)]) {
                    [_delegate sexChanged];
                }
                
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:@"更新失败" duration:2];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end
