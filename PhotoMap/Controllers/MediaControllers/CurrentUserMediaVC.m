//
//  CurrentUserMediaVC.m
//  PhotoMap
//
//  Created by Александр on 05.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "CurrentUserMediaVC.h"
#import "PMServerManager.h"

@interface CurrentUserMediaVC ()

@property (strong, nonatomic) NSString *nextMaxID;

@end

@implementation CurrentUserMediaVC

static NSInteger POSTS_IN_REQUEST = 5;
static NSString * kNextMaxIDKeyPath = @"pagination.next_max_id";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)getMedia {
    
    __weak CurrentUserMediaVC *weakSelf = self;
    [self.serverManager getCurrentUsersRecentMediaCount:@(POSTS_IN_REQUEST)
                                                               minID:@0
                                                               maxID:self.nextMaxID ? self.nextMaxID : @"0"
                                              onSuccess:^(NSDictionary *responseObject) {
                                                  
                                                  AALog(@"actionGetCurrentUserMedia SUCCESS");
                                                  weakSelf.nextMaxID = [responseObject valueForKeyPath:kNextMaxIDKeyPath];
                                                  [weakSelf mapResponseObject:responseObject];
                                                  
                                              } onFailure:^(NSError *error) {
                                                  AALog(@"actionGetCurrentUserMedia FAILURE");
                                              }];
}

@end
