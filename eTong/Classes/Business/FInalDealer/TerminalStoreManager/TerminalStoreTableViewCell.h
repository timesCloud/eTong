//
//  TerminalStoreTableViewCell.h
//  eTong
//
//  Created by TsaoLipeng on 15/6/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTerminalStoreCellHeight 100
@class TerminalStore;

@protocol TerminalStoreTableViewCellDelegate <NSObject>

@required
-(void)terminalStoreCellRightButtonClick;

@end

@interface TerminalStoreTableViewCell : UITableViewCell

@property (nonatomic) BOOL isEditMode;//是否为编辑模式，是则按照isContained规定显示，否则显示箭头
@property (nonatomic) BOOL isContained;//是否已被当前终极经销商管理，在编辑模式下，是则显示删除按钮，否则显示添加按钮
@property (nonatomic, weak) id<TerminalStoreTableViewCellDelegate> delegate;

-(void)setTerminalStore:(TerminalStore *)terminalStore;

@end
