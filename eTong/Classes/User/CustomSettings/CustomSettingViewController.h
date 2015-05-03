//
//  UICustomSettingViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSettingViewDelegate <NSObject>

@required
- (void)userSettingChanged;

@end

@interface CustomSettingViewController : UIViewController

@property (nonatomic, weak) id<CustomSettingViewDelegate> delegate;

@property (nonatomic) NSInteger settingMode;//为999时则表示是每次登陆后要求未完善资料的用户完善资料

@end
