//
//  PMPostPinAnnotationView.h
//  PhotoMap
//
//  Created by Alexandr on 20.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <MapKit/MapKit.h>

@class PMPost;

@interface PMPostPinAnnotationView : MKPinAnnotationView

- (void)configureWithPost:(PMPost *)post;

@end
