//
//  CustomDatePickerView.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/1.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerViewDelegate <NSObject>

@required
- (void)dateChanged;

@end

@interface CustomDatePickerView : UIView

@property (nonatomic, weak) id<CustomDatePickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withDefaultDate:(NSDate *)date;

@end
