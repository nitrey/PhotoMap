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

@property (readonly, nonatomic, strong) NSNumber *postID;
@property (readonly, nonatomic, strong) NSString *mediaID;
@property (readonly, nonatomic, strong) NSURL *userPhotoURL;
@property (readonly, nonatomic, strong) NSString *nickname;
@property (readonly, nonatomic, strong) NSString *location;
@property (readonly, nonatomic, strong) NSURL *postPhotoURL;
@property (readonly, nonatomic, assign) NSUInteger likesCount;
@property (readonly, nonatomic, assign) NSUInteger commentsCount;
@property (readonly, nonatomic, strong) NSString *postDescription;
@property (readonly, nonatomic, strong) NSArray *postHashtags; //of NSStrings
@property (readonly, nonatomic, strong) NSDictionary *postInfo;
@property (readonly, nonatomic, assign) CLLocationDegrees latitude;
@property (readonly, nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, strong) UIImage *userPhotoImage;
@property (nonatomic, strong) UIImage *postPhotoImage;

- (instancetype)initWithPostInfo:(NSDictionary *)postInfo;

@end
