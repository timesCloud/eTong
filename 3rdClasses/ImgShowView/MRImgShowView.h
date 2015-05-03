//
//  MRImgShowView.h
//
//  图片展示控件
//
//  Created by Minr on 14-11-15.
//  Copyright (c) 2014年 Minr. All rights reserved.
//

#import <UIKit/UIKit.h>



#pragma mark -ENUM
typedef NS_ENUM(NSInteger, MRImgLocation) {
    MRImgLocationLeft,
    MRImgLocationCenter,
    MRImgLocationRight,
};

#pragma mark -MRImgShowView
@interface MRImgShowView : UIScrollView <UIScrollViewDelegate>
{
    NSDictionary* _imgViewDic;   // 展示板组
}

@property(nonatomic ,assign)NSInteger curIndex;     // 当前显示图片在数据源中的下标

@property(nonatomic ,retain)NSMutableArray *imgSource;

@property(nonatomic ,readonly)MRImgLocation imgLocation;    // 图片在空间中的位置

- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame withSourceData:(NSMutableArray *)imgSource withIndex:(NSInteger)index;

// 谦让双击放大手势
- (void)requireDoubleGestureRecognizer:(UITapGestureRecognizer *)tep;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
