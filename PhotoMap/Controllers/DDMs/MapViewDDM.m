//
//  MapViewDDM.m
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "MapViewDDM.h"
#import "PMUser.h"

@implementation MapViewDDM

- (instancetype)initWithUser:(PMUser *)user {
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

#pragma mark - <MapAnnotationsDataSource>

- (NSArray *)objectsForAnnotations {
    return self.user.postsByUser;
}

@end
