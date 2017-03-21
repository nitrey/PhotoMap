//
//  MapViewController.h
//  PhotoMap
//
//  Created by Alexandr on 18.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMUser;

@protocol MapAnnotationsDataSource <NSObject>

@property (strong, nonatomic) PMUser *user;
@optional
- (NSArray *)objectsForAnnotations; //of id <MKAnnotation>

@end

@interface MapViewController : UIViewController

@property (strong, nonatomic) id <MapAnnotationsDataSource> dataSource;

@end
