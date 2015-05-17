//
//  SKUTableViewCell.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKU;

@interface SKUTableViewCell : UITableViewCell

-(void)setSKU:(SKU *)sku WithHighlighted:(BOOL)highlighted;

@end
