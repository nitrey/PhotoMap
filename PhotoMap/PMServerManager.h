//
//  PMServerManager.h
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAUtils.h"

typedef void(^GetSuccessBlock)(NSDictionary *responseObject);
typedef void(^ErrorBlock)(NSError *error);

@class PMAccessToken, PMUser, AFHTTPSessionManager;

@interface PMServerManager : NSObject

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) PMAccessToken *token;
@property (strong, nonatomic) PMUser *currentUser;

+ (PMServerManager *)sharedManager;

- (void)getAccessTokenWithCode:(NSString *)code
                     onSuccess:(GetSuccessBlock)success
                     onFailure:(ErrorBlock)failure;

- (void)getCurrentUserInfoOnSuccess:(GetSuccessBlock)success
                          onFailure:(ErrorBlock)failure;

- (void)getUserInfo:(NSString *)userID
          onSuccess:(GetSuccessBlock)success
          onFailure:(ErrorBlock)failure;

- (void)getCurrentUsersRecentMediaCount:(NSNumber *)count
                                  minID:(NSNumber *)minID
                                  maxID:(NSString *)maxID
                              onSuccess:(GetSuccessBlock)success
                              onFailure:(ErrorBlock)failure;

- (void)getUsersRecentMedia:(NSString *)userID
                      Count:(NSInteger)count
                      minID:(NSInteger)minID
                      maxID:(NSInteger)maxID
                  onSuccess:(GetSuccessBlock)success
                  onFailure:(ErrorBlock)failure;

- (void)getCurrentUserRecentMediaOnSuccess:(GetSuccessBlock)success
                                      onFailure:(ErrorBlock)failure;

- (void)getCommentsForMedia:(NSString *)mediaID
                  onSuccess:(GetSuccessBlock)success
                  onFailure:(ErrorBlock)failure;

- (void)getUsersRecentMedia:(NSString *)userID
                  OnSuccess:(GetSuccessBlock)success
                  onFailure:(ErrorBlock)failure;

- (void)getUsersLikedMediaCount:(NSString *)count
                          maxID:(NSString *)maxID
                      onSuccess:(GetSuccessBlock)success
                      onFailure:(ErrorBlock)failure;




@end
