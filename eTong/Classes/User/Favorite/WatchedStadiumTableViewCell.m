//
//  WatchedStadiumTableViewCell.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "WatchedStadiumTableViewCell.h"
#import "UIView+XD.h"
#import "Defines.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "ShareInstances.h"

#define lPortraitMargin 5
#define lMargin 10
#define lCellHeight 90
#define lPortraitSize 70

@interface WatchedStadiumTableViewCell()

@property (nonatomic, strong) UIImageView *headPortrait;
@property (nonatomic, strong) UILabel *stadiumNameLabel;
@property (nonatomic, strong) UILabel *stadiumAddressLabel;
@property (nonatomic, strong) UIButton *watchButton;

@end

@implementation WatchedStadiumTableViewCell{
    Stadium *curStadium;
}

- (instancetype)init{
    self = [super init];
    
    [self initialize];
    
    return self;
}

- (void)initialize{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.width, 80)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [ShareInstances addTopBottomBorderOnView:bgView];
    [self addSubview:bgView];
    
    _headPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(lPortraitMargin, lPortraitMargin, lPortraitSize, lPortraitSize)];
    [_headPortrait setContentMode:UIViewContentModeScaleAspectFill];
    [bgView addSubview:_headPortrait];
    
    _stadiumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headPortrait.right + lMargin, _headPortrait.y, self.width - _headPortrait.right - 40, 17)];
    [_stadiumNameLabel setFont:[UIFont systemFontOfSize:17]];
    [_stadiumNameLabel setTextColor:NORMAL_TEXT_COLOR];
    [bgView addSubview:_stadiumNameLabel];
    
    _stadiumAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stadiumNameLabel.x, _stadiumNameLabel.bottom + lMargin, _stadiumNameLabel.width, 13)];
    [_stadiumAddressLabel setFont:[UIFont systemFontOfSize:13]];
    [_stadiumAddressLabel setTextColor:LIGHT_TEXT_COLOR];
    [bgView addSubview:_stadiumAddressLabel];
    
    _watchButton = [[UIButton alloc] initWithFrame:CGRectMake(_stadiumNameLabel.x, _stadiumAddressLabel.bottom, 120, 40)];
    [_watchButton addTarget:self action:@selector(watchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_watchButton setImage:[UIImage imageNamed:@"heart_highlight.png"] forState:UIControlStateNormal];
    [_watchButton setImage:[UIImage imageNamed:@"heart_normal.png"] forState:UIControlStateHighlighted];
    [_watchButton setTitle:@"取消收藏" forState:UIControlStateNormal];
    [_watchButton setTitleColor:LINK_TEXT_COLOR forState:UIControlStateNormal];
    [_watchButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_watchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [bgView addSubview:_watchButton];
    
    UIView *splitter = [[UIView alloc] initWithFrame:CGRectMake(lPortraitMargin, lCellHeight, self.width - lPortraitMargin, 0.5f)];
    [splitter setBackgroundColor:SPLITTER_COLOR];
    [bgView addSubview:splitter];
}

- (void)setStadium:(Stadium *)stadium {
    curStadium = stadium;
    [_stadiumNameLabel setText:curStadium.name];
    [_stadiumAddressLabel setText:curStadium.address];
    [curStadium.portrait getThumbnail:YES width:lPortraitSize*2 height:lPortraitSize*2 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [_headPortrait setImage:image];
        }
    }];
}

- (void)watchButtonClick:(id)sender {
    AVUser *curUser = [AVUser currentUser];
    if (curUser != nil) {
        AVRelation *relation = [curUser relationforKey:@"watchedStadium"];
        [relation removeObject:curStadium];
        
        [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [_watchButton setImage:[UIImage imageNamed:@"heart_normal.png"] forState:UIControlStateNormal];
                [_watchButton setImage:[UIImage imageNamed:@"heart_highlight.png"] forState:UIControlStateHighlighted];
                [_watchButton setTitle:@"已取消收藏" forState:UIControlStateNormal];
            }
        }];
    }
}

+ (CGFloat)cellHeight{
    return lCellHeight;
}

@end
