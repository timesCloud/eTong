//
//  NormalNavigationBar.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NormalNavigationDelegate <NSObject>

@required
- (void)doReturn;
@optional
- (void)rightButtonClick;
@end

@interface NormalNavigationBar : UIView

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id<NormalNavigationDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title withRightButtonTitle:(NSString *)rightButtonTitle;

- (void)setTitle:(NSString *)title;

@end
