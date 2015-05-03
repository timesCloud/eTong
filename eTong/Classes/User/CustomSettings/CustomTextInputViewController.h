//
//  CustomTextInputViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/4/1.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTextInputViewDelegate <NSObject>

@required
- (void)textChangedOnRow:(NSInteger)row;

@end

@interface CustomTextInputViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title withRow:(NSInteger)row withOriginText:(NSString *)text withEditKey:(NSString *)key;
@property (nonatomic, weak) id<CustomTextInputViewDelegate> delegate;

@end
