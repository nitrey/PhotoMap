//
//  AbstractPostsViewController.h
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMServerManager, PMUser;

@interface AbstractPostsViewController : UIViewController

@property (nonatomic, strong) PMServerManager *serverManager;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) PMUser *user;

- (void)mapResponseObject:(NSDictionary *)responseObject;
- (void)performBlockOnMainQueue:(void(^)(void))block;

//abstract methods

- (void)getMedia;
- (void)updateDataManagerWithArray:(NSArray *)array;

@end
