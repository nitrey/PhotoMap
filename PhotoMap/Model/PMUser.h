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

@property (readonly, strong, nonatomic) NSString *username;
@property (readonly, strong, nonatomic) NSString *userID;
@property (readonly, strong, nonatomic) NSString *bio;
@property (readonly, strong, nonatomic) NSString *fullName;
@property (readonly, strong, nonatomic) NSURL *pictureURL;
@property (readonly, strong, nonatomic) NSURL *websiteURL;
@property (readonly, strong, nonatomic) NSNumber *postsCount;
@property (readonly, strong, nonatomic) NSNumber *followersCount;
@property (readonly, strong, nonatomic) NSNumber *followingCount;
@property (readonly, strong, nonatomic) NSArray *postsByUser; //of PMPosts

- (instancetype)initWithInfo:(NSDictionary *)info;
- (void)addPosts:(NSArray *)array;
- (void)addPost:(PMPost *)post;

@end
