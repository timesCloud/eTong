//
//  FavoriteSportSettingViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FavoriteSportSettingViewDelegate <NSObject>

@required
- (void)favoriteSportChanged;

@end

@interface FavoriteSportSettingViewController : UIViewController

@property (nonatomic, weak) id<FavoriteSportSettingViewDelegate> delegate;

@end
