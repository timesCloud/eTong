//
//  LocationView.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/4.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "LocationView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ShareInstances.h"
#import "UIView+XD.h"
#import "CustomLocationManager.h"
#import "Defines.h"

static CGFloat viewHeight = 60.0f;
static CGFloat locationLabelMarginRight = 5.0f;
static CGFloat locationLabelWidth = 80.0f;
static CGFloat locationLabelTextSize = 12.0f;
static CGFloat refreshButtonMarginRight = 24.0f;
static CGFloat refreshButtonSize = 44.0f;

@interface LocationView ()

@property (strong, nonatomic) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *refreshButton;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    // Do any additional setup after loading the view, typically from a nib.
    self.backgroundColor = [UIColor clearColor];
    
    [self initialize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationUpdated:) name:KNOTIFICATION_LOCATIONUPDATED object:nil];
    [[CustomeLocationManager defaultManager] updateLocation];
    //设置代理为自己
    return self;
}

+ (CGFloat)getViewHeight {
    return viewHeight;
}

- (void)initialize {
    _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(refreshButtonMarginRight, (viewHeight - refreshButtonSize) / 2, refreshButtonSize, refreshButtonSize)];
    [_refreshButton setImage:[UIImage imageNamed:@"refreshLocation.png"] forState:UIControlStateNormal];
    [_refreshButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_refreshButton];
    
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_refreshButton.frame.origin.x + _refreshButton.width + locationLabelMarginRight, _refreshButton.y, 8, refreshButtonSize)];
    [locationImageView setImage:[UIImage imageNamed:@"location_small_green.png"]];
    [locationImageView setContentMode:UIViewContentModeCenter];
    [self addSubview:locationImageView];
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationImageView.frame.origin.x + locationImageView.width + locationLabelMarginRight, _refreshButton.y, locationLabelWidth, refreshButtonSize)];
    [_locationLabel setTextColor:[UIColor grayColor]];
    [_locationLabel setFont:[UIFont systemFontOfSize:locationLabelTextSize]];
    [self addSubview:_locationLabel];
    
}

- (void)locationButtonClick:(UIButton *)sender {
    [[CustomeLocationManager defaultManager] updateLocation];
}

- (void)onLocationUpdated:(NSNotification *)notification
{
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:[ShareInstances getLastLocation] completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
            
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             _locationLabel.text = city;
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

@end
