//
//  PMUser.m
//  PhotoMap
//
//  Created by Александр on 22.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "PMUser.h"
#import "PMPost.h"

static NSString * kUserIDKeyPath = @"id";
static NSString * kUsernameKeyPath = @"username";
static NSString * kFullnameKeyPath = @"full_name";
static NSString * kBioKeyPath = @"bio";
static NSString * kPictureURLKeyPath = @"profile_picture";
static NSString * kFollowersCountKeyPath = @"counts.followed_by";
static NSString * kFollowingCountKeyPath = @"counts.follows";
static NSString * kWebsiteURLKeyPath = @"website";
static NSString * kPostsCountKeyPath = @"counts.media";

@interface PMUser ()

@property (strong, nonatomic) NSString *pictureURLString;
@property (strong, nonatomic) NSString *websiteURLString;
@property (strong, nonatomic) NSMutableArray *postsByUserIDs; //of NSString

@end

@implementation PMUser

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        _userID = [info valueForKeyPath:kUserIDKeyPath];
        _username = [info valueForKeyPath:kUsernameKeyPath];
        _fullName = [info valueForKeyPath:kFullnameKeyPath];
        _bio = [info valueForKeyPath:kBioKeyPath];
        _postsCount = [info valueForKeyPath:kPostsCountKeyPath];
        _followersCount = [info valueForKeyPath:kFollowersCountKeyPath];
        _followingCount = [info valueForKeyPath:kFollowingCountKeyPath];
        //checking if URLs are entities of NSNull class
        NSString *pictureURLString = [info valueForKeyPath:kPictureURLKeyPath];
        _pictureURLString = [pictureURLString isKindOfClass:[NSNull class]] ? nil : pictureURLString;
        NSString *websiteURLString = [info valueForKeyPath:kWebsiteURLKeyPath];
        _websiteURLString = [websiteURLString isKindOfClass:[NSNull class]] ? nil : websiteURLString;
        _postsByUser = @[];
        _postsByUserIDs = [NSMutableArray array];
    }
    return self;
}

- (instancetype)updateUserInfo:(NSDictionary *)info {
    if ([_username isEqualToString:[info valueForKeyPath:kUsernameKeyPath]]) {
        _userID = [info valueForKeyPath:kUserIDKeyPath];
        _fullName = [info valueForKeyPath:kFullnameKeyPath];
        _bio = [info valueForKeyPath:kBioKeyPath];
        _postsCount = [info valueForKeyPath:kPostsCountKeyPath];
        _followersCount = [info valueForKeyPath:kFollowersCountKeyPath];
        _followingCount = [info valueForKeyPath:kFollowingCountKeyPath];
        //checking if URLs are entities of NSNull class
        NSString *pictureURLString = [info valueForKeyPath:kPictureURLKeyPath];
        _pictureURLString = [pictureURLString isKindOfClass:[NSNull class]] ? nil : pictureURLString;
        NSString *websiteURLString = [info valueForKeyPath:kWebsiteURLKeyPath];
        _websiteURLString = [websiteURLString isKindOfClass:[NSNull class]] ? nil : websiteURLString;
    }
    return self;
}

- (NSURL *)pictureURL {
    return [NSURL URLWithString:self.pictureURLString];
}

- (NSURL *)websiteURL {
    return [NSURL URLWithString:self.websiteURLString];
}

#pragma mark - Adding new posts

- (void)addPosts:(NSArray *)array {
    for (PMPost *post in array) {
        [self addPost:post];
    }
}

- (void)addPost:(PMPost *)post {
    if ([self.postsByUserIDs containsObject:post.mediaID]) {
        return;
    }
    NSMutableArray *newArray = [self.postsByUser mutableCopy];
    [newArray addObject:post];
    [self.postsByUserIDs addObject:post.mediaID];
    _postsByUser = [newArray copy];
}

@end
