//
//  MapViewController.m
//  PhotoMap
//
//  Created by Alexandr on 18.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.title = @"PhotoMap";
    [self.mapView addAnnotations:[self.dataSource objectsForAnnotations]];
    [self.mapView showAnnotations:[self.dataSource objectsForAnnotations] animated:YES];
}

@end
