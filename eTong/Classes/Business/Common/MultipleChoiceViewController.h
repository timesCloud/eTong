//
//  FavoriteSportSettingViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultipleChoiceViewDelegate <NSObject>

@required
- (void)multipleSelectedChanged:(NSArray *)selected;

@end

@interface MultipleChoiceViewController : UIViewController

- (instancetype)initWithItemNames:(NSArray *)names withObjects:(NSArray *)objects withSelectedObjects:(NSArray *)selected;

@property (nonatomic, weak) id<MultipleChoiceViewDelegate> delegate;

@end
