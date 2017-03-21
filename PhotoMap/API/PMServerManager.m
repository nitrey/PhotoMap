//
//  PMServerManager.m
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "PMServerManager.h"

//API
#import "PMAccessToken.h"
#import "InstagramAPI.h"

//model
#import "PMUser.h"

//VCs
#import "PMLogoutViewController.h"

//helpers
#import "AAUtils.h"
#import <AFNetworking/AFNetworking.h>

NSString * const NewUserNotificationName = @"com.nitrey.NewUserNotificationName";
static NSString * const kAccessTokenNumber = @"access_token_key";
static NSString * const kCurrentUserInfoGetRequestFormat = @"https://api.instagram.com/v1/users/self?access_token=%@";
static NSString * const kCustomUserInfoGetRequestFormat = @"https://api.instagram.com/v1/%@?access_token=%@";

@interface PMServerManager ()

@property (readwrite, strong, nonatomic) PMUser *currentUser;
@property (readwrite, strong, nonatomic) PMAccessToken *token;

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
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        [self.sessionManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [self.sessionManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidLogout)
                                                     name:LogoutSuccessNotificationName
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userDidLogout {
    self.currentUser = nil;
    self.token = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kAccessTokenNumber];
    [userDefaults synchronize];
}

- (void)setToken:(PMAccessToken *)token {
    _token = token;
    if (token.number) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:token.number forKey:kAccessTokenNumber];
        [userDefaults synchronize];
    }
    AALog(@"ACCESS TOKEN RECEIVED: %@", token.number);
}

- (PMAccessToken *)token {
    if (!_token) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *number = [userDefaults valueForKey:kAccessTokenNumber];
        PMAccessToken *token = nil;
        if (number) {
            token = [[PMAccessToken alloc] initWithNumber:number];
        }
        _token = token;
    }
    return _token;
}


- (void)setCurrentUser:(PMUser *)currentUser {
    if (![_currentUser.username isEqualToString:currentUser.username]) {
        _currentUser = currentUser;
        if (currentUser != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NewUserNotificationName object:nil];
        }
    }
}

- (void)authorizeUser:(void(^)(PMUser *user))completion {
    NSDictionary *parameters = @{
         @"client_id": kInstagramClientID,
         @"redirect_uri": kInstagramRedirectURI,
         @"response_type": @"token",
    };
    [self.sessionManager GET:kInstagramAuthorizePath
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
                     onSuccess:(void(^)(void))success
                     onFailure:(ErrorBlock)failure {
    NSDictionary *parameters = @{
         @"client_id": kInstagramClientID,
         @"client_secret": kInstagramClientSecret,
         @"grant_type": @"authorization_code",
         @"redirect_uri": kInstagramRedirectURI,
         @"code": code,
    };
    NSMutableArray *params = [NSMutableArray array];
    
    for (id key in parameters) {
        id value = [parameters valueForKey:key];
        NSString *keyValuePair = [NSString stringWithFormat:@"%@=%@", key, value];
        [params addObject:keyValuePair];
    }
    NSString *paramString = [params componentsJoinedByString:@"&"];
    NSString *urlString = kInstagramReceiveAccessTokenPath;
    
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:@"POST"
                                                                                  URLString:urlString
                                                                                 parameters:nil
                                                                                      error:nil];
    [request setHTTPBody: [paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    __block NSURLSessionDataTask *task =
        [self.sessionManager dataTaskWithRequest:request
                               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                    if (error) {
                                        AALog(@"ERROR: %@", [error userInfo]);
                                        failure(error);
                                    } else {
                                        AALog(@"RESPONSE OBJECT: %@", [responseObject description ]);
                                        NSString *accessTokenNumber = responseObject[@"access_token"];
                                        self.token = [[PMAccessToken alloc] initWithNumber:accessTokenNumber];
                                        self.currentUser = [[PMUser alloc] initWithInfo:responseObject[@"user"]];
                                        success();
                                    }
                                    [task cancel];
                                }];
    [task resume];
}

- (void)getCurrentUserInfoOnSuccess:(GetSuccessBlock)success
                          onFailure:(ErrorBlock)failure {
    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", self.token.number];
    __weak typeof(self) weakSelf = self;
    [self.sessionManager GET:requestString
                                parameters:nil
                                  progress:nil
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                       
                                       if (!weakSelf.currentUser) {
                                           PMUser *user = [[PMUser alloc] initWithInfo:responseObject[@"data"]];
                                           weakSelf.currentUser = user;
                                       } else {
                                           PMUser *user = [weakSelf.currentUser updateUserInfo:responseObject[@"data"]];
                                           weakSelf.currentUser = user;
                                       }
                                       success(responseObject);
                                   }
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                       failure(error);
                                   }];
}

- (void)getCurrentUserRecentMediaCount:(NSNumber *)count
                                  minID:(NSString *)minID
                                  maxID:(NSString *)maxID
                              onSuccess:(GetSuccessBlock)success
                              onFailure:(ErrorBlock)failure {

    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?"
                               "access_token=%@&"
                               "count=%@&"
                               "min_id=%@&"
                               "max_id=%@",
                               self.token.number,
                               count,
                               minID,
                               maxID];
    
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

@end
