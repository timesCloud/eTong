//
//  GeoPointOper.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "CustomLocationManager.h"
#import "ShareInstances.h"
#import "Defines.h"

static CustomeLocationManager *instance;

@interface CustomeLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManage;

@end

@implementation CustomeLocationManager

+ (instancetype)defaultManager {
    @synchronized(self){
        if (!instance) {
            instance = [[CustomeLocationManager alloc] init];
        }
        
        return instance;
    }
}

+(id)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (!instance) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if([CLLocationManager locationServicesEnabled]){
        self.locationManage = [[CLLocationManager alloc] init];
        self.locationManage.delegate = self;
        self.locationManage.distanceFilter = 200;
        self.locationManage.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        if (SYSTEM_VERSION >= 8.0) {
            //使用期间
            [self.locationManage requestWhenInUseAuthorization];
            //始终
            //or [self.locationManage requestAlwaysAuthorization]
        }
        [self.locationManage startUpdatingLocation];
    }
    
    return self;
}

- (void)updateLocation {
    [self.locationManage startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManage respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locationManage requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    [ShareInstances setCurrentLocation:currentLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOCATIONUPDATED object:self];
    [self setLastAddress];
    [self.locationManage stopUpdatingLocation];
}

- (CLLocationDistance)getDistanceFromOrigin:(CLLocation *)origin toDest:(CLLocation *)dest {
    return [origin distanceFromLocation:dest];
}

- (CLLocationDistance)getDIstanceFromHereToAVDest:(AVGeoPoint *)dest {
    CLLocation *origin = [ShareInstances getLastLocation];
    CLLocation *cdest = [[CLLocation alloc] initWithLatitude:dest.latitude longitude:dest.longitude];
    return [self getDistanceFromOrigin:origin toDest:cdest];
}

- (CLLocation *)lastLocation{
    return [ShareInstances getLastLocation];
}

- (void)setLastAddress{
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:[ShareInstances getLastLocation] completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             NSMutableString *address = [[NSMutableString alloc] init];
             if (placemark.country != nil) [address appendString:placemark.country];
             if (placemark.administrativeArea != nil) [address appendString:placemark.administrativeArea];
             if (placemark.subAdministrativeArea != nil) [address appendString:placemark.subAdministrativeArea];
             if (placemark.locality != nil) [address appendString:placemark.locality];
             if (placemark.subLocality != nil) [address appendString:placemark.subLocality];
             if (placemark.thoroughfare != nil) [address appendString:placemark.thoroughfare];
             if (placemark.subThoroughfare != nil) [address appendString:placemark.subThoroughfare];
             if (placemark.name != nil) [address appendString:placemark.name];

             [ShareInstances setLastAddress:address];
         }
     }];

}

@end
