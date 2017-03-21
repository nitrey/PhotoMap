//
//  PMPost.m
//  PhotoMap
//
//  Created by Александр on 03.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PMPost.h"

static NSString * kPostID = @"caption.id";
static NSString * kMediaID = @"id";
static NSString * kUserImageURLKeyPath = @"caption.from.profile_picture";
static NSString * kUsernameKeyPath = @"caption.from.username";
static NSString * kPhotoLocationKeyPath = @"location.name";
static NSString * kPostPhotoURLKeyPath = @"images.standard_resolution.url";
static NSString * kPostPhotoThumbnailURLKeyPath = @"images.thumbnail.url";
static NSString * kLikesCountKeyPath = @"likes.count";
static NSString * kCommentsCountKeyPath = @"comments.count";
static NSString * kPostDescriptionKeyPath = @"caption.text";
static NSString * kPostTagsKeyPath = @"tags";
static NSString * kPostCoordinateLatitudeKeyPath = @"location.latitude";
static NSString * kPostCoordinateLongitudeKeyPath = @"location.longitude";
static CLLocationDegrees defaultLatitude = 59.905809;
static CLLocationDegrees dafaultLongitude = 30.368853;

@interface PMPost ()

@property (strong, nonatomic) NSString *userPhotoURLString;
@property (strong, nonatomic) NSString *postPhotoURLString;
@property (strong, nonatomic) NSString *postPhotoThumbnailURLString;

@end

@implementation PMPost

- (instancetype)initWithPostInfo:(NSDictionary *)postInfo {
    self = [super init];
    if (self != nil) {
        _postInfo = postInfo;
        _mediaID = [postInfo valueForKeyPath:kMediaID];
        _postID = [postInfo valueForKeyPath:kPostID];
        _nickname = [postInfo valueForKeyPath:kUsernameKeyPath];
        _location = [postInfo valueForKeyPath:kPhotoLocationKeyPath];
        _likesCount = [[postInfo valueForKeyPath:kLikesCountKeyPath] integerValue];
        _commentsCount = [[postInfo valueForKeyPath:kCommentsCountKeyPath] integerValue];
        _postDescription = [postInfo valueForKeyPath:kPostDescriptionKeyPath];
        _postHashtags = [postInfo valueForKeyPath:kPostTagsKeyPath];
        //checking if objects are entities of NSNull class
        id coordinateLatitude = [postInfo valueForKeyPath:kPostCoordinateLatitudeKeyPath];
        _latitude = [coordinateLatitude isKindOfClass:[NSNull class]] ? defaultLatitude : [coordinateLatitude doubleValue];
        id coordinateLongitude = [postInfo valueForKeyPath:kPostCoordinateLongitudeKeyPath];
        _longitude = [coordinateLongitude isKindOfClass:[NSNull class]] ? dafaultLongitude : [coordinateLongitude doubleValue];
        NSString *userImageURLString = [postInfo valueForKeyPath:kUserImageURLKeyPath];
        _userPhotoURLString = [userImageURLString isKindOfClass:[NSNull class]] ? nil : userImageURLString;
        NSString *postPhotoURLString = [postInfo valueForKeyPath:kPostPhotoURLKeyPath];
        _postPhotoURLString = [postPhotoURLString isKindOfClass:[NSNull class]] ? nil : postPhotoURLString;
        NSString *postPhotoThumbnailURLString = [postInfo valueForKeyPath:kPostPhotoThumbnailURLKeyPath];
        _postPhotoThumbnailURLString = [postPhotoThumbnailURLString isKindOfClass:[NSNull class]] ? nil : postPhotoThumbnailURLString;
    }
    return self;
}

- (NSURL *)userPhotoURL {
    return [NSURL URLWithString:self.userPhotoURLString];
}

- (NSURL *)postPhotoURL {
    return [NSURL URLWithString:self.postPhotoURLString];
}

- (NSURL *)postPhotoThumbnailURL {
    return [NSURL URLWithString:self.postPhotoThumbnailURLString];
}

@end
