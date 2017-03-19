//
//  PMUser.h
//  PhotoMap
//
//  Created by Александр on 22.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMPost;

@interface PMUser : NSObject

@property (readonly, nonatomic, strong) NSString *username;
@property (readonly, nonatomic, strong) NSString *userID;
@property (readonly, nonatomic, strong) NSString *bio;
@property (readonly, nonatomic, strong) NSString *fullName;
@property (readonly, nonatomic, strong) NSURL *pictureURL;
@property (readonly, nonatomic, strong) NSURL *websiteURL;
@property (readonly, nonatomic, strong) NSNumber *postsCount;
@property (readonly, nonatomic, strong) NSNumber *followersCount;
@property (readonly, nonatomic, strong) NSNumber *followingCount;
@property (readonly, nonatomic, strong) NSArray *postsByUser; //of PMPosts

- (instancetype)initWithInfo:(NSDictionary *)info;
- (void)addPosts:(NSArray *)array;
- (void)addPost:(PMPost *)post;

@end
