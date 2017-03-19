//
//  PMServerManager.m
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "PMAccessToken.h"
#import "PMServerManager.h"
#import "PMLoginViewController.h"

static NSString *const kAcessTokenNumber = @"access_token_key";

@interface PMServerManager ()

@end

@implementation PMServerManager

@synthesize token = _token;

+ (PMServerManager *)sharedManager {
    
    static PMServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PMServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL *baseURL = [NSURL URLWithString:@""];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        [self.sessionManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [self.sessionManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    }
    return self;
}

- (void)setToken:(PMAccessToken *)token {
    
    _token = token;
    
    if (token.number) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:token.number forKey:kAcessTokenNumber];
        [userDefaults synchronize];
    }
    
    AALog([NSString stringWithFormat:@"ACCESS TOKEN RECEIVED: %@", token.number]);
}

- (PMAccessToken *)token {
    
    if (!_token) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *number = [userDefaults valueForKey:kAcessTokenNumber];
        PMAccessToken *token = nil;
        if (number) {
            token = [[PMAccessToken alloc] initWithNumber:number];
        }
        _token = token;
    }
    return _token;
}

- (void)authorizeUser:(void(^)(PMUser *user))completion {
    
    NSDictionary *parameters = @{
         @"client_id": INSTAGRAM_CLIENT_ID,
         @"redirect_uri": INSTAGRAM_REDIRECT_URI,
         @"response_type": @"token",
    };
    
    [self.sessionManager GET:@"https://api.instagram.com/v1/oauth/authorize/"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         AALog(@"RESPONSE OBJECT: %@", [responseObject description]);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         AALog(@"ERROR: %@", [error userInfo]);
                     }];
}


- (void)getAccessTokenWithCode:(NSString *)code
                     onSuccess:(GetSuccessBlock)success
                     onFailure:(ErrorBlock)failure {
    
    NSDictionary *parameters = @{
         @"client_id": INSTAGRAM_CLIENT_ID,
         @"client_secret": INSTAGRAM_CLIENT_SECRET,
         @"grant_type": @"authorization_code",
         @"redirect_uri": INSTAGRAM_REDIRECT_URI,
         @"code": code,
    };
    
    NSMutableArray *params = [NSMutableArray array];
    
    for (id key in parameters) {
        
        id value = [parameters valueForKey:key];
        NSString *keyValuePair = [NSString stringWithFormat:@"%@=%@", key, value];
        [params addObject:keyValuePair];
    }
    
    NSString *paramString = [params componentsJoinedByString:@"&"];
    NSString *urlString = @"https://api.instagram.com/oauth/access_token";
    
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:@"POST"
                                                   URLString:urlString
                                                  parameters:nil
                                                       error:nil];
    
    [request setHTTPBody: [paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request
                                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                    
                                                                    if (error) {
                                                                        AALog(@"ERROR: %@", [error userInfo]);
                                                                        
                                                                    } else {
                                                                        AALog(@"RESPONSE OBJECT: %@", [responseObject description]);
                                                                        
                                                                        success(responseObject);
                                                                    }
                                                                    [task cancel];
                                                                }];
    [task resume];
}

- (void)getCurrentUserInfoOnSuccess:(GetSuccessBlock)success
                          onFailure:(ErrorBlock)failure {
    
    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", self.token.number];
    
    [self.sessionManager GET:requestString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         AALog(@"CURRENT USER INFO:\n%@", [responseObject description]);
                         success(responseObject);
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         AALog(@"%@", [error userInfo]);
                         failure(error);
                     }];
}

- (void)getUserInfo:(NSString *)userID
          onSuccess:(GetSuccessBlock)success
          onFailure:(ErrorBlock)failure {
    
    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/%@?access_token=%@", userID, self.token.number];
    
    [self.sessionManager GET:requestString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         success(responseObject);
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         AALog(@"%@", [error userInfo]);
                         failure(error);
                     }];
}

- (void)getCurrentUsersRecentMediaCount:(NSNumber *)count
                                  minID:(NSNumber *)minID
                                  maxID:(NSString *)maxID
                              onSuccess:(GetSuccessBlock)success
                              onFailure:(ErrorBlock)failure {
    
//    NSDictionary *parameters = @{
//                                 @"access_token" : self.token.number,
//                                 @"count" : @(count),
//                                 @"min_id" : @(minID),
//                                 @"max_id" : @(maxID),
//                                 };
    
//    NSString *requestEndpoint = @"/users/self/media/recent";
    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?access_token=%@&count=%@&min_id=%@&max_id=%@", self.token.number, count, minID, maxID];
    
    [self.sessionManager GET:requestString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         AALog(@"CURRENT USER INFO:\n%@", [responseObject description]);
                         success(responseObject);
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         AALog(@"%@", [error userInfo]);
                         failure(error);
                     }];
}


- (void)getUsersLikedMediaCount:(NSString *)count
                          maxID:(NSString *)maxID
                      onSuccess:(GetSuccessBlock)success
                      onFailure:(ErrorBlock)failure{
    
    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/liked?access_token=%@&max_like_id=%@&count=%@", self.token.number, maxID, count];
    
    [self.sessionManager GET:requestString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         AALog(@"USER'S LIKED MEDIA:\n%@", [responseObject description]);
                         
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         AALog(@"%@", [error userInfo]);
                     }];
}

- (void)getUsersRecentMedia:(NSString *)userID
                      Count:(NSInteger)count
                      minID:(NSInteger)minID
                      maxID:(NSInteger)maxID
                  onSuccess:(GetSuccessBlock)success
                  onFailure:(ErrorBlock)failure {
    
    NSDictionary *parameters = @{
                                 @"access_token" : self.token.number,
                                 @"count" : @(count),
                                 @"min_id" : @(minID),
                                 @"max_id" : @(maxID),
                                 };
    
    NSString *requestEndpoint = [NSString stringWithFormat:@"/users/%@/media/recent", userID];
    
    [self.sessionManager GET:requestEndpoint
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         AALog(@"CURRENT USER INFO:\n%@", [responseObject description]);
                         success(responseObject);
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         AALog(@"%@", [error userInfo]);
                         failure(error);
                     }];
}

- (void)getCommentsForMedia:(NSString *)mediaID
                  onSuccess:(GetSuccessBlock)success
                  onFailure:(ErrorBlock)failure {
    
    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/%@/comments?access_token=%@", mediaID, self.token.number];
    
    [self.sessionManager GET:requestString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         success(responseObject);
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         AALog(@"%@", [error userInfo]);
                         failure(error);
                     }];
}

- (void)getCurrentUserRecentMediaOnSuccess:(GetSuccessBlock)success
                                      onFailure:(ErrorBlock)failure {
    
    
}

- (void)getUsersRecentMedia:(NSString *)userID
                  OnSuccess:(GetSuccessBlock)success
                  onFailure:(ErrorBlock)failure {
    
    
}

@end
