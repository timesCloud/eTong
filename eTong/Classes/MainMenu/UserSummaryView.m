//
//  UserSummaryView.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "UserSummaryView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ShareInstances.h"
#import "Defines.h"
#import "UIView+XD.h"

static NSInteger welcomeLabelHeight = 60;

@interface UserSummaryView ()

@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation UserSummaryView{
    NSMutableArray *cells;
    UILabel *welcomeLabel;
}

- (instancetype)init {
    self = [super init];
    [self initUserStatu];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    [self setBackgroundColor:MAIN_COLOR];
    
    CGRect frame = CGRectMake(200, 20, 44, welcomeLabelHeight);
    UIImageView *goImageView = [[UIImageView alloc] initWithFrame:frame];
    [goImageView setImage:[UIImage imageNamed:@"go_white.png"]];
    [goImageView setContentMode:UIViewContentModeCenter];
    [self addSubview:goImageView];
    
    return self;
}

- (void)refreshSignStatu {
    AVUser *curUser = [AVUser currentUser];
    
    if (curUser != nil)
        [ShareInstances setCurrentUserHeadPortraitWithUserName:curUser.username];
    
    [self addSubview:self.portraitImageView];
    [ShareInstances loadPortraitOnView:_portraitImageView withDefaultImageName:DEFAULT_PORTRAIT_INVERSE];
    
    if (welcomeLabel == nil) {
        welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 120, welcomeLabelHeight)];
        [self addSubview:welcomeLabel];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:welcomeLabel.frame];
        [loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
    }
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:15];
    welcomeLabel.textAlignment = NSTextAlignmentLeft;
    welcomeLabel.text = curUser == nil ? @"Hi 你好 点击登录" : [NSString stringWithFormat:@"Hi %@", [curUser objectForKey:@"nickname"]];
    
}

- (void)initUserStatu {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [self refreshSignStatu];
}

-(void)loginStateChange:(NSNotification *)notification {
    [self refreshSignStatu];
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = 40.0f;
        CGFloat h = w;
        CGFloat x = 22.0f;
        CGFloat y = 30.0f;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.layer.borderColor = [MAIN_COLOR CGColor];
        _portraitImageView.layer.borderWidth = 0.5f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doLogin)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

- (void)doLogin {
    if ([AVUser currentUser] != nil) {
        if ([_delegate respondsToSelector:@selector(onUserHome)])
            [_delegate onUserHome];
    } else {
        if ([_delegate respondsToSelector:@selector(onLogin)])
            [_delegate onLogin];
    }
}


@end
