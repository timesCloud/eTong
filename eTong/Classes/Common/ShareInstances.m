//
//  ShareInstances.m
//  Bauma360
//
//  Created by TsaoLipeng on 15/1/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ShareInstances.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "SVProgressHUD.h"
#import "FinalDealer.h"

static AVUser *lastUser;
static UIImage *currentUserHeadPortrait;
static UIImage *currentUserHeadPortraitThumbnail;
static CLLocation *lastLocation;
static NSString *lastAddress;
static TerminalStore *currentTerminalStore;
static FinalDealer *currentFinalDealer;

@implementation ShareInstances

+ (void)setCurrentUserHeadPortraitWithUserName:(NSString *)username {
    AVQuery *query = [AVUser query];
    [query whereKey:@"username" equalTo:username];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 3600 * 24;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            AVUser *user = [objects objectAtIndex:0];
            AVFile *headPortraitFile = [user objectForKey:@"headPortrait"];
            [headPortraitFile getThumbnail:YES width:88 height:88 withBlock:^(UIImage *image, NSError *error) {
                if (!error) {
                    currentUserHeadPortraitThumbnail = image;
                }
            }];
            [headPortraitFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    currentUserHeadPortrait = [UIImage imageWithData:data];
                }
            }];
        }
    }];
}

+ (void)setCurrentUserHeadPortrait:(UIImage *)headPortrait {
    currentUserHeadPortrait = headPortrait;
    CGSize thumbnailSize = CGSizeMake(88, 88);
    currentUserHeadPortraitThumbnail = [self originImage:currentUserHeadPortrait scaleToSize:thumbnailSize];
}

+ (UIImage *)getCurrentUserHeadPortrait {
    return currentUserHeadPortrait;
}

+ (void)setCurrentUserHeadPortraitThumbnail:(UIImage *)headPortrait {
    currentUserHeadPortraitThumbnail = headPortrait;
}

+ (UIImage *)getCurrentUserHeadPortraitThumbnail {
    return currentUserHeadPortraitThumbnail;
}

+(UIImage*) originImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (void)setCurrentLocation:(CLLocation *)location {
    lastLocation = location;
}

+ (CLLocation *)getLastLocation {
    return lastLocation;
}

+ (AVGeoPoint *)getLastGeoPoint {
    AVGeoPoint *point = [[AVGeoPoint alloc] init];
    point.latitude = lastLocation.coordinate.latitude;
    point.longitude = lastLocation.coordinate.longitude;
    return point;
}

+ (void)setLastAddress:(NSString *)address{
    lastAddress = address;
}

+ (NSString *)getLastAddress{
    return lastAddress;
}

+ (void)loadPortraitOnView:(UIImageView *)view withDefaultImageName:(NSString *)imageName forceReload:(BOOL)forceRaload {
    AVUser *curUser = [AVUser currentUser];
    if (curUser != nil) {
        if (curUser != lastUser || forceRaload) {
            AVFile *imageFile = [curUser objectForKey:@"headPortrait"];
            if (imageFile != nil) {
                [imageFile getThumbnail:YES width:150 height:150 withBlock:^(UIImage * image, NSError *error) {
                    if (!error) {
                        currentUserHeadPortrait = image;
                        view.image = currentUserHeadPortrait;
                        lastUser = curUser;
                    } else {
                        view.image = [UIImage imageNamed:imageName];
                    }
                }];
            } else {
                view.image = [UIImage imageNamed:imageName];
            }
        } else {
            if (currentUserHeadPortrait != nil) {
                view.image = currentUserHeadPortrait;
            } else
                view.image = [UIImage imageNamed:imageName];
        }
    } else {
        view.image = [UIImage imageNamed:imageName];
    }
}

+ (void)loadPortraitOnView:(UIImageView *)view withDefaultImageName:(NSString *)imageName{
    [self loadPortraitOnView:view withDefaultImageName:imageName forceReload:NO];
}

+ (void)setCurPortrait:(UIImage *)image {
    lastUser = [AVUser currentUser];
    currentUserHeadPortrait = image;
}

//为视图右侧增加一个箭头图片
+ (void)addRightArrowOnView:(UIView *)view {
    UIImageView *goAccountDetail = [[UIImageView alloc] initWithFrame:CGRectMake(view.width - 44, 0, 44, view.height)];
    [goAccountDetail setImage:[UIImage imageNamed:@"go_normal.png"]];
    [goAccountDetail setContentMode:UIViewContentModeCenter];
    [view addSubview:goAccountDetail];
}
//为视图添加上下0.5宽的边框
+ (void)addTopBottomBorderOnView:(UIView *)view {
    [ShareInstances addTopBorderOnView:view];
    [ShareInstances addBottomBorderOnView:view];
}
+ (void)addAllBorderOnView:(UIView *)view{
    [ShareInstances addTopBottomBorderOnView:view];
    
    UIView *leftBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, view.height)];
    leftBorderView.backgroundColor = SPLITTER_COLOR;
    [view addSubview:leftBorderView];
    
    UIView *rightBorderView = [[UIView alloc] initWithFrame:CGRectMake(view.width - 0.5, 0, 0.5, view.height)];
    rightBorderView.backgroundColor = SPLITTER_COLOR;
    [view addSubview:rightBorderView];
}
+ (void)addTopBorderOnView:(UIView *)view{
    UIView *topBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 0.5)];
    topBorderView.backgroundColor = SPLITTER_COLOR;
    topBorderView.tag = 999;
    [view addSubview:topBorderView];
}
+ (void)addBottomBorderOnView:(UIView *)view{
    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 0.5, view.width, 0.5)];
    bottomBorderView.backgroundColor = SPLITTER_COLOR;
    bottomBorderView.tag = 999;
    [view addSubview:bottomBorderView];
}
+ (void)addBottomSepratorBorderOnView:(UIView *)view{
    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(15, view.height - 0.5, view.width, 0.5)];
    bottomBorderView.backgroundColor = SPLITTER_COLOR;
    bottomBorderView.tag = 999;
    [view addSubview:bottomBorderView];
}

+ (void)NormalNetworkErrorHUD{
    [SVProgressHUD showErrorWithStatus:@"网络不给力，请稍候重试" duration:2];
}

+(UILabel *)addLabel:(NSString *)text withFrame:(CGRect)frame withSuperView:(UIView *)superView withTextColor:(UIColor *)color withAlignment:(NSTextAlignment)alignment withTextSize:(CGFloat)textSize{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setFont:[UIFont systemFontOfSize:textSize]];
    [label setTextColor:color];
    [label setTextAlignment:alignment];
    [label setText:text];
    [superView addSubview:label];
    return label;
}

+(UILabel *)addSubTitleLabel:(NSString *)title withFrame:(CGRect)frame withSuperView:(UIView *)superView{
    return [ShareInstances addLabel:title withFrame:frame withSuperView:superView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_SUBTITLE];
}

+(UIImageView *)addGoIndicateOnView:(UIView *)view withImageFrame:(CGRect)frame{
    UIImageView *goImageView = [[UIImageView alloc] initWithFrame:frame];
    [goImageView setImage:[UIImage imageNamed:@"go_normal.png"]];
    [goImageView setContentMode:UIViewContentModeCenter];
    [view addSubview:goImageView];
    return goImageView;
}

+(UIImageView *)addGoIndicateOnView:(UIView *)view{
    return [ShareInstances addGoIndicateOnView:view withImageFrame:CGRectMake(view.width - 44, (view.height - 44) / 2, 44, 44)];
}

+(UIView *)addItemViewOnView:(UIView *)parent withY:(CGFloat)y withHeight:(CGFloat)height withTitle:(NSString *)title canTouchUpInside:(BOOL)canTouchUpInside sender:(id)sender action:(SEL)action{
    UILabel *titleLabel = [ShareInstances addSubTitleLabel:title withFrame:CGRectMake(MARGIN_NARROW, y, parent.width - MARGIN_NARROW * 2, TEXTSIZE_SUBTITLE) withSuperView:parent];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + MARGIN_NARROW, parent.width, height)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [parent addSubview:view];
    [ShareInstances addBottomBorderOnView:view];
    if (canTouchUpInside) {
        [ShareInstances addGoIndicateOnView:view];
        UITapGestureRecognizer *brandViewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:sender action:action];
        [view addGestureRecognizer:brandViewTapGR];
    }
    
    return view;
}

+(UIView *)addNormalItemViewOnView:(UIView *)parent withY:(CGFloat)y withTitle:(NSString *)title canTouchUpInside:(BOOL)canTouchUpInside sender:(id)sender action:(SEL)action{
    return [ShareInstances addItemViewOnView:parent withY:y withHeight:44 withTitle:title canTouchUpInside:canTouchUpInside sender:sender action:action];
}

+(UILabel *)addModifiableLabelOnView:(UIView *)parent withDefaultText:(NSString *)text{
    UILabel *label = [ShareInstances addLabel:text withFrame:CGRectMake(MARGIN_WIDE, (parent.height - TEXTSIZE_BIG) / 2, parent.width - MARGIN_WIDE * 2 - 44, TEXTSIZE_BIG) withSuperView:parent withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    return label;
}

+(void)setCurrentTerminalStore:(TerminalStore *)terminalStore{
    currentTerminalStore = terminalStore;
}

+(TerminalStore *)getCurrentTerminalStore{
    return currentTerminalStore;
}

+(void)setCurrentFinalDealer:(FinalDealer *)finalDealer{
    currentFinalDealer = finalDealer;
}

+(FinalDealer *)getCurrentFinalDealer{
    return currentFinalDealer;
}

@end
