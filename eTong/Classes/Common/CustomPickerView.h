//
//  CustomPickerView.h
//  eTong
//
//  Created by TsaoLipeng on 15/5/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerViewDelegate <NSObject>

@required
-(void)selectedIndexChanged:(NSInteger)index withTag:(NSInteger)tag;

@end

@interface CustomPickerView : UIView

@property (nonatomic, weak) id<CustomPickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withOptionArray:(NSArray *)optionArrays withDefaultIndex:(NSInteger)index;

@end
