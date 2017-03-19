//
//  PMPost+MapAnnotation.m
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PMPost+MapAnnotation.h"

@implementation PMPost (MapAnnotation)

#pragma mark - <MKAnnotation>

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
