//
//  PackingStockTableViewCell.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/21.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PackingSpecification;

@protocol PackingStockTableViewCellDelegate <NSObject>

@required
-(void)packing:(PackingSpecification *)packing StockEntried:(NSInteger)stock;
-(void)packing:(PackingSpecification *)packing PurchaseEntried:(NSInteger)purchase;

@end

@interface PackingStockTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier entryMode:(NSInteger)mode;
-(void)setPackingSpecification:(PackingSpecification *)packingSpecification;

@property (nonatomic, weak) id<PackingStockTableViewCellDelegate> delegate;

@end
