//
//  PreNavigationViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/6.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "PreNavigationViewController.h"
#import "NormalNavigationBar.h"
#import <AVOSCloud/AVOSCloud.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CustomAnnotation.h"
#import "UIView+XD.h"
#import "CustomAnnotationView.h"
#import "ShareInstances.h"

@interface PreNavigationViewController()<MKMapViewDelegate, NormalNavigationDelegate>{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    CustomAnnotation *targetAnnotation;
    CLLocationCoordinate2D targetLocation;
}

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation PreNavigationViewController

- (instancetype)initWithLocation:(AVGeoPoint *)geoPoint withTargetPortrait:(AVFile *)portrait withTitle:(NSString *)title withSubTitle:(NSString *)subTitle {
    self = [super init];
    targetLocation = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    targetAnnotation = [[CustomAnnotation alloc]init];
    targetAnnotation.imageFile = portrait;
    targetAnnotation.title = title;
    targetAnnotation.subtitle = subTitle;
    targetAnnotation.coordinate = targetLocation;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initGUI];
}

#pragma mark 添加地图控件
-(void)initGUI{
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"场馆位置" withRightButtonTitle:@"导航"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    _mapView=[[MKMapView alloc]initWithFrame:CGRectMake(self.view.x, _navigationBar.bottom, self.view.width, self.view.height - _navigationBar.bottom)];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc] init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    //添加大头针
    [_mapView addAnnotation:targetAnnotation];
    
    CLLocation *location = [ShareInstances getLastLocation];
    MKMapPoint point1 = MKMapPointForCoordinate(location.coordinate);
    MKMapPoint point2 = MKMapPointForCoordinate(targetLocation);
    MKMapRect rect1 = MKMapRectMake(point1.x, point1.y, 0, 0);
    MKMapRect rect2 = MKMapRectMake(point2.x, point2.y, 0, 0);
    MKMapRect r = MKMapRectUnion(rect1, rect2);
    double newWidth = r.size.width * 2;
    double newHeight = r.size.height * 2;
    double newX = r.origin.x - r.size.width * 0.5;
    double newY = r.origin.y - r.size.width * 0.5;
    r = MKMapRectMake(newX, newY, newWidth, newHeight);
    [_mapView setVisibleMapRect:r animated:YES];
}

#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@",userLocation);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //    [_mapView setRegion:region animated:true];
}

#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
//    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
//        static NSString *key1=@"AnnotationKey";
//        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
//        //如果缓存池中不存在则新建
//        if (!annotationView) {
//            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
//            annotationView.canShowCallout=true;//允许交互点击
//            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
//            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"football.png"]];//定义详情左侧视图
//        }
//        
//        //修改大头针视图
//        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
//        annotationView.annotation=annotation;
//        [((CustomAnnotation *)annotation).imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            if (!error && data != nil) {
//                //annotationView.image = [UIImage imageWithData:data];
//            }
//        }];
//        
//        return annotationView;
//    }else {
//        return nil;
//    }
//}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick {
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:targetLocation addressDictionary:nil];
    NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
    [mapItem openInMapsWithLaunchOptions:options];
}

@end
