//
//  AVSubclassesHelper.m
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "AVSubclassesHelper.h"
#import "Stadium.h"
#import "StadiumType.h"
#import "StadiumSpecification.h"
#import "StadiumImage.h"
#import "sportField.h"
#import "SpecialDay.h"
#import "ReservationOrder.h"
#import "ReservationSuborder.h"
#import "Bulletin.h"

@implementation AVSubclassesHelper

+(void) RegisterSubclasses {
    [Stadium registerSubclass];
    [StadiumType registerSubclass];
    [StadiumSpecification registerSubclass];
    [StadiumImage registerSubclass];
    [District registerSubclass];
    [SportField registerSubclass];
    [SpecialDay registerSubclass];
    [ReservationOrder registerSubclass];
    [ReservationSuborder registerSubclass];
    [Bulletin registerSubclass];
}

@end
