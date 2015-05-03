//
//  MenuHrizontal.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "ScheduleHorizontalMenu.h"
#import "ScheduleHorizontalMenuCell.h"
#import "UIView+XD.h"

#define BUTTONITEMWIDTH   70

@implementation ScheduleHorizontalMenu

#pragma mark 初始化菜单

- (id)initWithFrame:(CGRect)frame withStadium:(Stadium *)stadium withDate:(NSDate *)date {
    self = [super initWithFrame:frame];
    self.height = kScheduleHorizontalMenuCellHeight + 10;
    if (self) {
        if (mButtonArray == nil) {
            mButtonArray = [[NSMutableArray alloc] init];
        }
        if (mScrollView == nil) {
            mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            mScrollView.showsHorizontalScrollIndicator = NO;//滚动时不显示水平滚动条
        }
        if (mItemInfoArray == nil) {
            mItemInfoArray = [[NSMutableArray alloc]init];
        }
        [mItemInfoArray removeAllObjects];
        [self createMenuItemsWithStadium:stadium withDate:date];
    }
    return self;
}

-(void)createMenuItemsWithStadium:(Stadium *)stadium withDate:(NSDate *)date {
    float menuWidth = 0.0;
    NSDate *tempDate;
    for (int i = 0; i < 7; i++) {
        tempDate = [date dateByAddingTimeInterval:3600 * 24 * i];
        ScheduleHorizontalMenuCell *cell = [[ScheduleHorizontalMenuCell alloc] initWithOriginX:kScheduleHorizontalMenuCellWidth * i + 5 * (i + 1) withOriginY:5];
        [cell initializeWithStadium:stadium withDate:tempDate];
        cell.tag = i;
        [mScrollView addSubview:cell];
        [mButtonArray addObject:cell];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doViewTap:)];
        [cell addGestureRecognizer:tapGR];
        
        menuWidth = (kScheduleHorizontalMenuCellWidth + 5) * (i + 1) + 5;
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [[NSMutableDictionary alloc] init];
        [vNewDic setObject:[NSNumber numberWithFloat:menuWidth] forKey:TOTALWIDTH];
        [mItemInfoArray addObject:vNewDic];
    }
    
    [mScrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [self addSubview:mScrollView];
    // 保存menu总长度，如果小于320则不需要移动，方便点击button时移动位置的判断
    mTotalWidth = menuWidth;
}

- (void)refreshCellsWithStadium:(Stadium *)stadium withDate:(NSDate *)date {
    NSDate *tempDate;
    for (int i = 0; i < 7; i++) {
        tempDate = [date dateByAddingTimeInterval:3600 * 24 * i];
        ScheduleHorizontalMenuCell *cell = [mButtonArray objectAtIndex:i];
        [cell updateCellWithStadium:stadium withDate:tempDate];
    }
}

- (void)doViewTap:(id)sender {
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer *)sender;
    if (tapGR.view != nil) {
        [self changeButtonStateAtIndex:tapGR.view.tag];
        if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
            [_delegate didMenuHrizontalClickedButtonAtIndex:tapGR.view.tag];
        }
    }
}

#pragma mark - 其他辅助功能
#pragma mark 取消所有button点击状态
//-(void)changeButtonsToNormalState{
//    for (UIButton *vButton in mButtonArray) {
//        vButton.selected = NO;
//        [vButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    }
//}

#pragma mark 模拟选中第几个button
-(void)clickButtonAtIndex:(NSInteger)aIndex{
    ScheduleHorizontalMenuCell *vCell = [mButtonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vCell];
}

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex{
    ScheduleHorizontalMenuCell *vCell = [mButtonArray objectAtIndex:aIndex];
    //[self changeButtonsToNormalState];
    //vButton.selected = YES;
    //[vButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self moveScrolViewWithIndex:aIndex];
}

#pragma mark 将所有button预置为非选中状态

#pragma mark 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex{
    if (mItemInfoArray.count < aIndex) {
        return;
    }
     //宽度小于320肯定不需要移动
    if (mTotalWidth <= 320) {
        return;
    }
    NSDictionary *vDic = [mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    if (vButtonOrigin >= 300) {
        if ((vButtonOrigin + 180) >= mScrollView.contentSize.width) {
            [mScrollView setContentOffset:CGPointMake(mScrollView.contentSize.width - 320, mScrollView.contentOffset.y) animated:YES];
            return;
        }
        
        float vMoveToContentOffset = vButtonOrigin - 180;
        if (vMoveToContentOffset > 0) {
            [mScrollView setContentOffset:CGPointMake(vMoveToContentOffset, mScrollView.contentOffset.y) animated:YES];
        }
//        NSLog(@"scrollwOffset.x:%f,ButtonOrigin.x:%f,mscrollwContentSize.width:%f",mScrollView.contentOffset.x,vButtonOrigin,mScrollView.contentSize.width);
    }else{
        [mScrollView setContentOffset:CGPointMake(0, mScrollView.contentOffset.y) animated:YES];
            return;
    }
}

#pragma mark - 点击事件
-(void)menuButtonClicked:(ScheduleHorizontalMenuCell *)aCell{
    [self changeButtonStateAtIndex:aCell.tag];
    if ([_delegate respondsToSelector:@selector(didMenuHrizontalClickedButtonAtIndex:)]) {
        [_delegate didMenuHrizontalClickedButtonAtIndex:aCell.tag];
    }
}


#pragma mark 内存相关
-(void)dealloc{
    [mButtonArray removeAllObjects],mButtonArray = nil;
}

@end
