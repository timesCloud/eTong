//
//  SKUSearchResultViewController.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/18.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKU;

@interface SKUSearchResultViewController : UIViewController

-(instancetype)initWithSKU:(SKU *)sku;

@property (nonatomic, weak) UIView *skuView;

@end
