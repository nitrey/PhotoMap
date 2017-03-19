//
//  MapViewController.m
//  PhotoMap
//
//  Created by Alexandr on 18.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "MapViewController.h"
#import "MapViewDDM.h"
#import "PMServerManager.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapViewController];
}

- (void)setupMapViewController {
    self.title = @"PhotoMap";
    self.dataSource = [[MapViewDDM alloc] initWithUser:[PMServerManager sharedManager].currentUser];
    [self.mapView addAnnotations:[self.dataSource objectsForAnnotations]];
    [self.mapView showAnnotations:[self.dataSource objectsForAnnotations] animated:YES];
}

@end
