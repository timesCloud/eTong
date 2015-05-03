//
//  SettingTableViewCell.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

- (void)setKey:(NSString *)key withValue:(NSString *)value;
- (void)setKey:(NSString *)key withImage:(UIImage *)image;

@end
