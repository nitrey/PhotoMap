//
//  PMServerManager.h
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const NewUserNotificationName;

@class PMAccessToken, PMUser, AFHTTPSessionManager;

typedef void(^GetSuccessBlock)(NSDictionary *responseObject);
typedef void(^ErrorBlock)(NSError *error);

@interface PMServerManager : NSObject

@property (readonly, strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (readonly, strong, nonatomic) PMAccessToken *token;
@property (readonly, strong, nonatomic) PMUser *currentUser;

+ (PMServerManager *)sharedManager;

- (void)getAccessTokenWithCode:(NSString *)code
                     onSuccess:(void(^)(void))success
                     onFailure:(ErrorBlock)failure;

- (void)getCurrentUserInfoOnSuccess:(GetSuccessBlock)success
                          onFailure:(ErrorBlock)failure;

- (void)getCurrentUserRecentMediaCount:(NSNumber *)count
                                  minID:(NSString *)minID
                                  maxID:(NSString *)maxID
                              onSuccess:(GetSuccessBlock)success
                              onFailure:(ErrorBlock)failure;

- (void)getCommentsForMedia:(NSString *)mediaID
                  onSuccess:(GetSuccessBlock)success
                  onFailure:(ErrorBlock)failure;

@end
