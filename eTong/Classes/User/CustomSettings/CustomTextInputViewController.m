//
//  CustomTextInputViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/4/1.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "CustomTextInputViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "ShareInstances.h"

@interface CustomTextInputViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation CustomTextInputViewController{
    NSInteger editRow;
    NSString *originText;
}

- (instancetype)initWithTitle:(NSString *)title withRow:(NSInteger)row withOriginText:(NSString *)text{
    self = [super init];
    
    editRow = row;
    originText = text;
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    _navigationBar = [[NormalNavigationBar alloc] initWithTitle:title withRightButtonTitle:@"确定"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIView *tfBgView = [[UIView alloc] initWithFrame:CGRectMake(5, _navigationBar.bottom + 5, self.view.width - 10, 44)];
    [tfBgView setBackgroundColor:[UIColor whiteColor]];
    [ShareInstances addAllBorderOnView:tfBgView];
    [self.view addSubview:tfBgView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0.5, tfBgView.width - 1, tfBgView.height - 1)];
    [_textField setFont:[UIFont systemFontOfSize:17]];
    [_textField setTextColor:NORMAL_TEXT_COLOR];
    [_textField setTextAlignment:NSTextAlignmentLeft];
    [_textField setText:originText];
    [tfBgView addSubview:_textField];
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_textField becomeFirstResponder];
}

#pragma mark NormalNavigationDelegate
- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick {
    [_textField setEnabled:NO];

    if ([_delegate respondsToSelector:@selector(textChanged:OnRow:)]) {
        [_delegate textChanged:_textField.text OnRow:editRow];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
