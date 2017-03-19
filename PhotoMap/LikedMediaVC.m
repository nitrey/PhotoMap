//
//  LikedMediaVC.m
//  PhotoMap
//
//  Created by Александр on 05.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "LikedMediaVC.h"
#import "PMServerManager.h"

@interface LikedMediaVC ()

@property (strong, nonatomic) NSString *nextMaxID;

@end

@implementation LikedMediaVC

static NSString * POSTS_IN_REQUEST = @"4";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)getMedia {
    
    [self.serverManager getUsersLikedMediaCount:POSTS_IN_REQUEST
                                                       maxID:self.nextMaxID ? self.nextMaxID : @"0"
                                                   onSuccess:^(NSDictionary *responseObject) {
                                                       
                                                   }
                                                   onFailure:^(NSError *error) {
                                                       
                                                   }];
}

@end
