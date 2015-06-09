//
//  ShareInstances.h
//  Bauma360
//
//  Created by TsaoLipeng on 15/1/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "TerminalStore.h"

@interface ShareInstances : NSObject

+ (void)setCurrentUserHeadPortraitWithUserName:(NSString *)username;

+ (void)setCurrentUserHeadPortrait:(UIImage *)headPortrait;
+ (UIImage *)getCurrentUserHeadPortrait;

+ (void)setCurrentUserHeadPortraitThumbnail:(UIImage *)headPortrait;
+ (UIImage *)getCurrentUserHeadPortraitThumbnail;

+ (void)setCurrentLocation:(CLLocation *)location;
+ (CLLocation *)getLastLocation;
+ (AVGeoPoint *)getLastGeoPoint;

+ (void)loadPortraitOnView:(UIImageView *)view withDefaultImageName:(NSString *)imageName;
+ (void)loadPortraitOnView:(UIImageView *)view withDefaultImageName:(NSString *)imageName forceReload:(BOOL)forceRaload;
+ (void)setCurPortrait:(UIImage *)image;
//视图修饰方法
+ (void)addRightArrowOnView:(UIView *)view;
+ (void)addTopBottomBorderOnView:(UIView *)view;
+ (void)addAllBorderOnView:(UIView *)view;
+ (void)addTopBorderOnView:(UIView *)view;
+ (void)addBottomBorderOnView:(UIView *)view;
+ (void)addBottomSepratorBorderOnView:(UIView *)view;


+ (void)NormalNetworkErrorHUD;

+(UILabel *)addSubTitleLabel:(NSString *)title withFrame:(CGRect)frame withSuperView:(UIView *)superView;
+(UILabel *)addLabel:(NSString *)text withFrame:(CGRect)frame withSuperView:(UIView *)superView withTextColor:(UIColor *)color withAlignment:(NSTextAlignment)alignment withTextSize:(CGFloat)textSize;
+(UIImageView *)addGoIndicateOnView:(UIView *)view;
+(UIView *)addNormalItemViewOnView:(UIView *)parent withY:(CGFloat)y withTitle:(NSString *)title canTouchUpInside:(BOOL)canTouchUpInside sender:(id)sender action:(SEL)action;
+(UILabel *)addModifiableLabelOnView:(UIView *)parent;

+(void)setCurrentTerminalStore;
+(TerminalStore *)getCurrentTerminalStore;

@end
