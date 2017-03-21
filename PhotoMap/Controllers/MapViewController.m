//
//  MapViewController.m
//  PhotoMap
//
//  Created by Alexandr on 18.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "PMPost.h"
#import "PMServerManager.h"

//controllers
#import "SinglePostVC.h"
#import "MapViewDDM.h"

@interface MapViewController () <MapViewDDMDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapViewController];
}

- (void)setupMapViewController {
    self.title = @"PhotoMap";
    MapViewDDM *ddm = [[MapViewDDM alloc] initWithUser:[PMServerManager sharedManager].currentUser];
    self.dataSource = ddm;
    ddm.delegate = self;
    self.mapView.delegate = ddm;
    [self.mapView addAnnotations:[self.dataSource objectsForAnnotations]];
    [self.mapView showAnnotations:[self.dataSource objectsForAnnotations] animated:YES];
}

#pragma mark - <MapViewDDMDelegate>

- (void)needsShowPost:(PMPost *)post {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SinglePostVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"SinglePostVC"];
    vc.post = post;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
