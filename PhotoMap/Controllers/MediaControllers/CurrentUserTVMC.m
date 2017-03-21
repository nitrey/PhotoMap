//
//  CurrentUserMediaVC.m
//  PhotoMap
//
//  Created by Александр on 05.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "CurrentUserTVMC.h"
#import "PMServerManager.h"
#import "AAUtils.h"

@interface CurrentUserTVMC ()

@property (strong, nonatomic) NSString *nextMaxID;

@end

@implementation CurrentUserTVMC

static NSInteger POSTS_IN_REQUEST = 20;
static NSString * kNextMaxIDKeyPath = @"pagination.next_max_id";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)getMedia {
    __weak CurrentUserTVMC *weakSelf = self;
    [self.serverManager getCurrentUserRecentMediaCount:@(POSTS_IN_REQUEST)
                                                               minID:@"0"
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
