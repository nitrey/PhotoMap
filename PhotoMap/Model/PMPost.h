//
//  PMPost.h
//  PhotoMap
//
//  Created by Александр on 03.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class UIImage;

@interface PMPost : NSObject

@property (readonly, strong, nonatomic) NSNumber *postID;
@property (readonly, strong, nonatomic) NSString *mediaID;
@property (readonly, strong, nonatomic) NSURL *userPhotoURL;
@property (readonly, strong, nonatomic) NSString *nickname;
@property (readonly, strong, nonatomic) NSString *location;
@property (readonly, strong, nonatomic) NSURL *postPhotoURL;
@property (readonly, strong, nonatomic) NSURL *postPhotoThumbnailURL;
@property (readonly, assign, nonatomic) NSUInteger likesCount;
@property (readonly, assign, nonatomic) NSUInteger commentsCount;
@property (readonly, strong, nonatomic) NSString *postDescription;
@property (readonly, strong, nonatomic) NSArray *postHashtags; //of NSStrings
@property (readonly, strong, nonatomic) NSDictionary *postInfo;
@property (readonly, assign, nonatomic) CLLocationDegrees latitude;
@property (readonly, assign, nonatomic) CLLocationDegrees longitude;
@property (strong, nonatomic) UIImage *userPhotoImage;
@property (strong, nonatomic) UIImage *postPhotoImage;
@property (strong, nonatomic) UIImage *postPhotoThumbnailImage;

- (instancetype)initWithPostInfo:(NSDictionary *)postInfo;

@end
