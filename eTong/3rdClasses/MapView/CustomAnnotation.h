//
//  KCAnnotation.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/6.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface CustomAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic,strong) AVFile *imageFile;

@end