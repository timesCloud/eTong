//
//  PreNavigationViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/6.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface PreNavigationViewController : UIViewController

- (instancetype)initWithLocation:(AVGeoPoint *)geoPoint withTargetPortrait:(AVFile *)portrait withTitle:(NSString *)title withSubTitle:(NSString *)subTitle;

@end
