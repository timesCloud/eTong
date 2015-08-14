//
//  TerminalStoreTableView.h
//  eTong
//
//  Created by TsaoLipeng on 15/6/25.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TerminalStoreTableViewDelegate <NSObject>

@required
- (void)loadDataByClearAll:(BOOL)needClearAll withComplete:(void(^)(NSArray *data, BOOL successed))complete;

@end

@interface TerminalStoreTableView : UITableView

-(void)forceRefreshData;

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller isEditMode:(BOOL)isEditMode;

@property (nonatomic, weak) id<TerminalStoreTableViewDelegate> tsDelegate;

@end
