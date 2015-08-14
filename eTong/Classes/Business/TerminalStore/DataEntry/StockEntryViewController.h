//
//  StockEntryView.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/11.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKU;
@class TerminalStore;

@protocol StockEntryViewDelegate <NSObject>

@required
-(void)stockDataChanged:(SKU *)sku;

@end

@interface StockEntryViewController : UIViewController

- (instancetype)initWithSku:(SKU *)sku mode:(NSInteger)mode;

@property (nonatomic, weak) id<StockEntryViewDelegate> delegate;
@property (nonatomic, strong) TerminalStore *curTerminalStore;

@end
