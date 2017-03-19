//
//  PMPost+MapAnnotation.h
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PMPost.h"

@interface PMPost (MapAnnotation) <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
