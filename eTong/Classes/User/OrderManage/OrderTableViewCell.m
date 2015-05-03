//
//  NotPaidTableViewCell.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/15.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "Defines.h"
#import "UIView+XD.h"

#define lMargin 10
#define lContentMargin 8
#define lTitleTextSize 17
#define lContentTextSize 14
#define lButtonWidth 50
#define lButtonHeight 20
#define cOrderCellHeight lMargin*2+lTitleTextSize+lContentTextSize*2+lContentMargin*3+0.5f

@interface OrderTableViewCell()

@property (nonatomic, strong) UILabel *stadiumNameLabel;
@property (nonatomic, strong) UILabel *statuLabel;
@property (nonatomic, strong) UILabel *sportFieldNameLabel;
@property (nonatomic, strong) UILabel *captchaLabel;
@property (nonatomic, strong) UILabel *datetimeLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *splitterView2;

@end

@implementation OrderTableViewCell {
    ReservationOrder *curOrder;
}

- (instancetype)init {
    self = [super init];
    
    [self setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(lMargin, lMargin / 2, self.width - lMargin * 2, 0)];
    [_backView setBackgroundColor:[UIColor whiteColor]];
    _backView.layer.borderColor = (__bridge CGColorRef)(MAIN_COLOR);
    _backView.layer.borderWidth = 0.5f;
    _backView.layer.cornerRadius = 4.0f;
    [self addSubview:_backView];
    
    _stadiumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(lContentMargin, lContentMargin, self.width - 108, lTitleTextSize)];
    [_stadiumNameLabel setTextColor:[UIColor darkTextColor]];
    [_stadiumNameLabel setFont:[UIFont systemFontOfSize:lTitleTextSize]];
    [_stadiumNameLabel setText:@"正在获取场馆..."];
    [_backView addSubview:_stadiumNameLabel];
    
    _statuLabel = [[UILabel alloc] initWithFrame:CGRectMake(_stadiumNameLabel.right, _stadiumNameLabel.y, self.width - _stadiumNameLabel.width, _stadiumNameLabel.height)];
    [_statuLabel setTextColor: LIGHT_TEXT_COLOR];
    [_statuLabel setTextAlignment:NSTextAlignmentCenter];
    [_statuLabel setFont:[UIFont systemFontOfSize:lContentTextSize]];
    [_backView addSubview:_statuLabel];
    
    UIView *splitterView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _stadiumNameLabel.bottom + lContentMargin, _backView.width, 0.5f)];
    [splitterView1 setBackgroundColor:SPLITTER_COLOR];
    [_backView addSubview:splitterView1];
    
    _sportFieldNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(lContentMargin, splitterView1.bottom + lContentMargin, (self.width - lContentMargin * 3) / 2, lContentTextSize)];
    [_sportFieldNameLabel setTextColor:NORMAL_TEXT_COLOR];
    [_sportFieldNameLabel setFont:[UIFont systemFontOfSize:lContentTextSize]];
    [_backView addSubview:_sportFieldNameLabel];
    
    _captchaLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sportFieldNameLabel.right + lContentMargin, _sportFieldNameLabel.y, _sportFieldNameLabel.width, lContentTextSize)];
    [_captchaLabel setTextColor:NORMAL_TEXT_COLOR];
    [_captchaLabel setFont:[UIFont systemFontOfSize:lContentTextSize]];
    [_backView addSubview:_captchaLabel];
    
    _datetimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(lContentMargin, _sportFieldNameLabel.bottom + lContentMargin, _sportFieldNameLabel.width, lContentTextSize)];
    [_datetimeLabel setTextColor:NORMAL_TEXT_COLOR];
    [_datetimeLabel setFont:[UIFont systemFontOfSize:lContentTextSize]];
    [_backView addSubview:_datetimeLabel];
    
    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_datetimeLabel.right + lContentMargin, _datetimeLabel.y, _datetimeLabel.width, lContentTextSize)];
    [_amountLabel setTextColor:NORMAL_TEXT_COLOR];
    [_amountLabel setFont:[UIFont systemFontOfSize:lContentTextSize]];
    [_backView addSubview:_amountLabel];
    
    _splitterView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _amountLabel.bottom + lContentMargin, _backView.width, 0.5f)];
    [_splitterView2 setBackgroundColor:SPLITTER_COLOR];
    [_backView addSubview:_splitterView2];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - lButtonWidth * 2 - lContentMargin - lMargin, _splitterView2.bottom + lContentMargin, lButtonWidth, lButtonHeight)];
    [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:LIGHT_BACKGROUND_COLOR];
    [_cancelButton.titleLabel setTextColor:NORMAL_TEXT_COLOR];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:lContentTextSize]];
    _cancelButton.layer.cornerRadius = 3.0f;
    _cancelButton.layer.masksToBounds = YES;
    [_backView addSubview:_cancelButton];
    
    _payButton = [[UIButton alloc] initWithFrame:CGRectMake(_cancelButton.right + lMargin, _cancelButton.y, lButtonWidth, lButtonHeight)];
    [_payButton setTitle:@"支付" forState:UIControlStateNormal];
    [_payButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_payButton.titleLabel setBackgroundColor:[UIColor orangeColor]];
    [_payButton.titleLabel setFont:[UIFont systemFontOfSize:lContentTextSize]];
    _payButton.layer.cornerRadius = 3.0f;
    _payButton.layer.masksToBounds = YES;
    [_backView addSubview:_payButton];
    
    return self;
}

- (void)setReservationOrder:(ReservationOrder *)order {
    curOrder = order;
    
    [curOrder.stadium fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error && object != nil) {
            [_stadiumNameLabel setText:((Stadium *)object).name];
        }
    }];
    
    if (curOrder.isPaid) {
        [_statuLabel setText:@"已支付"];
        [_captchaLabel setText:[NSString stringWithFormat:@"验证码：%@", curOrder.captcha]];
        [_backView setHeight:_amountLabel.bottom + lContentMargin];
        [_splitterView2 setHidden:YES];
        [_cancelButton setHidden:YES];
        [_payButton setHidden:YES];
    } else if ([[NSDate date] timeIntervalSinceDate:order.generateDateTime] < 60 * 15) {
        [_statuLabel setText:@"等待支付"];
        [_captchaLabel setText:@"验证码：暂无"];
        [_backView setHeight:_payButton.bottom + lContentMargin];
        [_splitterView2 setHidden:NO];
        [_cancelButton setHidden:NO];
        [_payButton setHidden:NO];
    } else {
        [_statuLabel setText:@"已取消"];
        [_statuLabel setTextColor:[UIColor redColor]];
        [_captchaLabel setText:@"验证码：无"];
        [_backView setHeight:_amountLabel.bottom + lContentMargin];
        [_splitterView2 setHidden:YES];
        [_cancelButton setHidden:YES];
        [_payButton setHidden:YES];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"时间：YYYY-MM-dd"];
    [_datetimeLabel setText:[dateFormatter stringForObjectValue:curOrder.date]];
    
    [_amountLabel setText:[NSString stringWithFormat:@"总金额：%ld", [curOrder.amount integerValue]]];
}

+ (CGFloat)cellHeight {
    return lMargin+lTitleTextSize+lContentTextSize*2+lContentMargin*5+0.5f;
}

@end
