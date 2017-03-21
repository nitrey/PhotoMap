//
//  MapViewDDM.m
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "MapViewDDM.h"

//annotations
#import "PMPostPinAnnotationView.h"

//model
#import "PMUser.h"
#import "PMPost.h"

//helpers
#import "PMImageDownloader.h"
#import "TextTagDecorator.h"

@implementation MapViewDDM

- (instancetype)initWithUser:(PMUser *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

#pragma mark - <MKMapViewDelegate>

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *viewIdentifier = @"MapViewDDM";
    PMPostPinAnnotationView *view = (PMPostPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:viewIdentifier];
    if (!view) {
        view = [[PMPostPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewIdentifier];
        view.pinTintColor = [UIColor blueColor];
    }
    view.annotation = annotation;
    if ([annotation isKindOfClass:[PMPost class]]) {
        PMPost *post = (PMPost *)annotation;
        [view configureWithPost:post];
    }
    return view;
}

- (void)updateLeftCalloutViewOfAnnotationView:(MKAnnotationView *)view {
    UIImageView *imageView;
    if (![view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        return;
    }
    imageView = (UIImageView *)view.leftCalloutAccessoryView;
    PMPost *post;
    if (![view.annotation isKindOfClass:[PMPost class]]) {
        return;
    }
    post = (PMPost *)view.annotation;
    if (post.postPhotoImage) {
        imageView.image = post.postPhotoImage;
    } else {
        [[PMImageDownloader sharedDownloader] downloadImage:post.postPhotoThumbnailURL completion:^(UIImage *image) {
            imageView.image = image;
        }];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if (![control isKindOfClass:[UIButton class]]) {
        return;
    }
    if (![view.annotation isKindOfClass:[PMPost class]]) {
        return;
    }
    PMPost *post = view.annotation;
    [self showPostPage:post];
    [mapView deselectAnnotation:view.annotation animated:YES];
}

#pragma mark - Actions

- (void)showPostPage:(PMPost *)post {
    [self.delegate needsShowPost:post];
}

#pragma mark - <MapAnnotationsDataSource>

- (NSArray *)objectsForAnnotations {
    return self.user.postsByUser;
}

@end
