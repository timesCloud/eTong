//
//  SorryView.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/20.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface SorryView : UIView

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller;

@property(nonatomic,weak) RootViewController *homeViewController;

@end
