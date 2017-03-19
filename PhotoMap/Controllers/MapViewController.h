//
//  MapViewController.h
//  PhotoMap
//
//  Created by Alexandr on 18.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapAnnotationsDataSource <NSObject>

@optional
- (NSArray *)objectsForAnnotations;

@end

@interface MapViewController : UIViewController

@property (nonatomic, strong) id <MapAnnotationsDataSource> dataSource;

@end
