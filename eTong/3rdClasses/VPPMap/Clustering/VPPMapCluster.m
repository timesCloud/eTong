//
//  VPPMapCluster.m
//  VPPLibraries
//
//  Created by Víctor on 09/12/11.

// 	Copyright (c) 2012 Víctor Pena Placer (@vicpenap)
// 	http://www.victorpena.es/
// 	
// 	
// 	Permission is hereby granted, free of charge, to any person obtaining a copy 
// 	of this software and associated documentation files (the "Software"), to deal
// 	in the Software without restriction, including without limitation the rights 
// 	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// 	copies of the Software, and to permit persons to whom the Software is furnished
// 	to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in
// 	all copies or substantial portions of the Software.
// 	
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// 	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// 	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// 	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
// 	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "VPPMapCluster.h"

#define kAnnotationsNumber @"%d annotations"

@implementation VPPMapCluster
@synthesize pinAnnotationColor;
@synthesize opensWhenShown;
@synthesize annotations;

- (VPPMapCluster *) init {
    if (self = [super init]) {
        self.annotations = [NSMutableArray array];
    }
    
    return self;
}

- (NSString *) title {
    return [NSString stringWithFormat:kAnnotationsNumber,[self.annotations count]];
}

- (CLLocationCoordinate2D) coordinate {
    float lat = 0;
    float lon = 0;
    
    for (id<MKAnnotation> ann in self.annotations) {
        lat += ann.coordinate.latitude;
        lon += ann.coordinate.longitude;
    }
    
    return CLLocationCoordinate2DMake(lat/[self.annotations count], lon/[self.annotations count]);
}


@end
