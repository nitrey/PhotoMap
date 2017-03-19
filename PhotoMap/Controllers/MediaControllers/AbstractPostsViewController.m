//
//  AbstractPostsViewController.m
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "AbstractPostsViewController.h"
#import "PMServerManager.h"
#import "PostMappingOperation.h"

@implementation AbstractPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAbstractPostsViewController];
}

- (void)setupAbstractPostsViewController {
    self.serverManager = [PMServerManager sharedManager];
    self.queue = [[NSOperationQueue alloc] init];
}

#pragma mark - API

- (void)getMedia {
    //ABSTRACT METHOD, SHOULD BE OVERRIDDEN BY CONCRETE SUBCLASSES
}

- (void(^)(void))blockUpdatingUI {
    //ABSTRACT METHOD, SHOULD BE OVERRIDDEN BY CONCRETE SUBCLASSES
    return nil;
}

- (void)mapResponseObject:(NSDictionary *)responseObject {
    
    if (responseObject != nil) {
        PostMappingOperation *mapping = [[PostMappingOperation alloc] initWithDictionary:responseObject];
        
        __weak PostMappingOperation *weakMapping = mapping;
        __weak typeof(self) weakSelf = self;
        
        mapping.completionBlock = ^{
            [weakSelf updateDataManagerWithArray:weakMapping.result];
        };
        [self.queue addOperation:mapping];
    }
}

#pragma mark - Supporting methods

- (void)updateDataManagerWithArray:(NSArray *)array {
    //ABSTRACT METHOD, SHOULD BE OVERRIDDEN BY CONCRETE SUBCLASSES
}

- (void)performBlockOnMainQueue:(void(^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

@end
