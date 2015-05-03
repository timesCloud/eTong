//
//  MenuCell.h
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (strong, nonatomic) UIImage *normalImage;
@property (strong, nonatomic) UIImage *highlightImage;

@end
