//
//  TerminalStoreMapView.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/26.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStoreMapViewController.h"
#import <MapKit/MapKit.h>
#import "VPPMapHelperDelegate.h"
#import "VPPMapHelper.h"
#import "MapAnnotationExample.h"
#import "TerminalStore.h"
#import "ShareInstances.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "TerminalStoreDetailViewController.h"
#import "NormalNavigationBar.h"

@interface TerminalStoreMapViewController()<VPPMapHelperDelegate, NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation TerminalStoreMapViewController{
    VPPMapHelper *mh;
    MKMapView *mapView;
    NSArray *terminalStores;
    NSMutableArray *places;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"终端店地图"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, size.width, size.height - _navigationBar.bottom - 44)];
    [self.view addSubview:mapView];
    
    mh = [VPPMapHelper VPPMapHelperForMapView:mapView
                             pinAnnotationColor:MKPinAnnotationColorGreen
                          centersOnUserLocation:NO
                          showsDisclosureButton:YES
                                       delegate:self];
    mapView.showsUserLocation = YES;
    mh.userCanDropPin = YES;
    mh.allowMultipleUserPins = YES;
    mh.pinDroppedByUserClass = [MapAnnotationExample class];
    
    [self queryTerminalStore];
    //[self tonsOfPins];
}

-(void)queryTerminalStore{
    AVRelation *relation = [[ShareInstances getCurrentFinalDealer] relationforKey:@"terminalStores"];
    AVQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            terminalStores = objects;
            places = [[NSMutableArray alloc] init];
            for (TerminalStore *store in objects) {
                MapAnnotationExample *place = [[MapAnnotationExample alloc] init];
                place.coordinate = CLLocationCoordinate2DMake(store.location.latitude, store.location.longitude);
                [place setTitle:store.storeName];
                place.pinAnnotationColor = MKPinAnnotationColorRed;
                place.opensWhenShown = YES;
                [places addObject:place];
            }
            //mh.shouldClusterPins = YES;
            [mh setMapAnnotations:places];
        }
    }];
}

-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark VPPMapHelperDelegate

- (void) open:(id<MKAnnotation>)annotation {
    for (TerminalStore *store in terminalStores) {
        if (annotation.coordinate.latitude == store.location.latitude && annotation.coordinate.longitude == store.location.longitude && annotation.title == store.storeName) {
            TerminalStoreDetailViewController *tsdVC = [[TerminalStoreDetailViewController alloc] initWithTerminalStore:store];
            [self.navigationController pushViewController:tsdVC animated:YES];
            break;
        }
    }
}

- (BOOL) annotationDroppedByUserShouldOpen:(id<MKAnnotation>)annotation {
    MapAnnotationExample *ann = (MapAnnotationExample*)annotation;
    
    ann.title = @"Hi there!";
    ann.pinAnnotationColor = MKPinAnnotationColorGreen;
    
    return YES;
}

@end
