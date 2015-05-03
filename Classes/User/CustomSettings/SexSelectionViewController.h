//
//  SexSelectionViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/31.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SexSelectionViewDelegate <NSObject>

@required
- (void)sexChanged;

@end

@interface SexSelectionViewController : UIViewController

- (void)setInitSex:(NSInteger)sex;

@property (nonatomic, weak) id<SexSelectionViewDelegate> delegate;

@end
