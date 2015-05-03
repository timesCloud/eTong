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

@end
