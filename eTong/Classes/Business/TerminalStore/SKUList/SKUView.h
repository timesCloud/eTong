//
//  SKUView.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface SKUView : UIView

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller;

@property(nonatomic,weak) RootViewController *homeViewController;

@end
