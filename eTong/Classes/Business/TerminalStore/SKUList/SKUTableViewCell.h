//
//  SKUTableViewCell.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSKUViewCellUnhighlightHeight 105

@class SKU;

@interface SKUTableViewCell : UITableViewCell

-(void)setSKU:(SKU *)sku;

@end
