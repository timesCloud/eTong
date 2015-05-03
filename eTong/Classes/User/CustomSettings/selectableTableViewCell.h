//
//  selectableTableViewCell.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/2.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectableTableViewCellDelegate <NSObject>

@required
- (void)cellSelectionChanged:(BOOL)selected withObjectIndex:(NSInteger)index;

@end

@interface SelectableTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SelectableTableViewCellDelegate> delegate;

- (void)setTitle:(NSString *)title withObjectIndex:(NSInteger)index selected:(BOOL)selected;

@end
