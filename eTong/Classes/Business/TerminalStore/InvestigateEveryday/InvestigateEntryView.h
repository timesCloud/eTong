//
//  InvestigateEntryView.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface InvestigateEntryView : UIView

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller;

@property(nonatomic,weak) RootViewController *homeViewController;

@end
