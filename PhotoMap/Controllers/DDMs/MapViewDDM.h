//
//  MapViewDDM.h
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@class PMUser;

@interface MapViewDDM : NSObject <MapAnnotationsDataSource, MKMapViewDelegate>

@property (strong, nonatomic) PMUser *user;

- (instancetype)initWithUser:(PMUser *)user;

@end
