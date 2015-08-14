//
//  TerminalStoreTableViewCell.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStoreTableViewCell.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "UIView+XD.h"
#import "TerminalStore.h"

@interface TerminalStoreTableViewCell()

@property (retain, nonatomic) UIImageView *headerImageView;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *telNoLabel;
@property (retain, nonatomic) UILabel *summaryLabel;
@property (retain, nonatomic) UIButton *rightButton;

@end

@implementation TerminalStoreTableViewCell{
    TerminalStore *curTerminalStore;
}
@synthesize titleLabel, summaryLabel, headerImageView, telNoLabel;

-(void)setTerminalStore:(TerminalStore *)terminalStore{
    curTerminalStore = terminalStore;
    [titleLabel setText:terminalStore.storeName];
    [telNoLabel setText:[NSString stringWithFormat:@"联系电话：%@", terminalStore.telNo]];
    
    [terminalStore.shopKeeper fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            [summaryLabel setText:[object objectForKey:@"nickname"]];
        }
    }];
    
    headerImageView.image = nil;
    CGFloat width = (kTerminalStoreCellHeight - MARGIN_WIDE * 2) * 2;
    [terminalStore.shopFrontPhoto getThumbnail:YES width:width height:width withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [headerImageView setImage:image];
        }
    }];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_WIDE, MARGIN_WIDE, kTerminalStoreCellHeight - MARGIN_WIDE * 2, kTerminalStoreCellHeight - MARGIN_WIDE * 2)];
        headerImageView.layer.cornerRadius = 4.0f;
        headerImageView.layer.masksToBounds = YES;
        [self addSubview:headerImageView];
        
        CGSize size = [[UIScreen mainScreen] applicationFrame].size;
        titleLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(headerImageView.right + MARGIN_WIDE, headerImageView.y, size.width - headerImageView.right - MARGIN_WIDE - 44, TEXTSIZE_BIG) withSuperView:self withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
        telNoLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(titleLabel.x, titleLabel.bottom + MARGIN_WIDE, titleLabel.width, TEXTSIZE_SUBTITLE) withSuperView:self withTextColor:LIGHT_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_SUBTITLE];
        summaryLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(telNoLabel.x, telNoLabel.bottom + MARGIN_WIDE, telNoLabel.width, headerImageView.height - telNoLabel.bottom) withSuperView:self withTextColor:LIGHT_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_SUBTITLE];
        
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 64, (kTerminalStoreCellHeight - 44) / 2, 64, 44)];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [self addSubview:_rightButton];

    }
    return self;
}

-(void)setIsEditMode:(BOOL)isEditMode{
    _isEditMode = isEditMode;
    [self setOperMode];
}

-(void)setIsContained:(BOOL)isContained{
    _isContained = isContained;
    [self setOperMode];
}

-(void)setOperMode{
    if (_isEditMode) {
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonClick)];
        [_rightButton addGestureRecognizer:tapGR];
        if (_isContained) {
            [_rightButton setImage:[UIImage imageNamed:@"less.png"] forState:UIControlStateNormal];
        }else{
            [_rightButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        }
    }else{
        [_rightButton setImage:[UIImage imageNamed:@"go_normal.png"] forState:UIControlStateNormal];
    }
}

-(void)rightButtonClick{
    if ([_delegate respondsToSelector:@selector(terminalStoreCellRightButtonClick:)] && _isEditMode) {
        [_delegate terminalStoreCellRightButtonClick:curTerminalStore];
    }
}

@end
