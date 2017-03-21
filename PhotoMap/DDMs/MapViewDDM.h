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

@class PMUser, PMPost;

@protocol MapViewDDMDelegate <NSObject>

- (void)needsShowPost:(PMPost *)post;

@end

@interface MapViewDDM : NSObject <MKMapViewDelegate, MapAnnotationsDataSource>

@property (strong, nonatomic) PMUser *user;
@property (weak, nonatomic) id <MapViewDDMDelegate> delegate;

- (instancetype)initWithUser:(PMUser *)user;

@end
