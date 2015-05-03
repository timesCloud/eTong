//
//  IndustrySettingViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/2.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IndustrySettingViewDelegate <NSObject>

@required
- (void)industryChanged;

@end

@interface IndustrySettingViewController : UIViewController

@property (nonatomic, weak) id<IndustrySettingViewDelegate> delegate;

@end
