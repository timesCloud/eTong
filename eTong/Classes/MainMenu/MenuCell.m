//
//  MenuCell.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuCell.h"
#import "Defines.h"

@implementation MenuCell {
    BOOL _isHighlightBeforeHidden;
}

- (void)awakeFromNib {
    // Initialization code
    //取消选中颜色
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView = backView;
    self.selectedBackgroundView.backgroundColor = MAINMENU_COLOR;
        
    //取消边框线
    [self setBackgroundView:[[UIView alloc] init]];          //取消边框线
    self.backgroundColor = MAINMENU_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setHighlightStatu:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self setHighlightStatu:highlighted];
}

- (void)setHighlightStatu:(BOOL)highlighted {
    if (highlighted) {
        _icon.image = _highlightImage;
        [_label setFont:[UIFont systemFontOfSize:18]];
        _label.textColor = [UIColor whiteColor];
    } else {
        _icon.image = _normalImage;
        [_label setFont:[UIFont systemFontOfSize:15]];
        _label.textColor = NORMAL_BACKGROUND_COLOR;
    }
}

@end
