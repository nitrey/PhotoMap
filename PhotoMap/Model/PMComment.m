//
//  PMComment.m
//  PhotoMap
//
//  Created by Alexandr on 10.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PMComment.h"

static NSString *const kTextKeyPath = @"text";
static NSString *const kUsernameKeyPath = @"from.username";
static NSString *const kUserPhotoKeyPath = @"from.profile_picture";

@interface PMComment ()

@property (strong, nonatomic) NSString *userPhotoURLString;

@end

@implementation PMComment

- (instancetype)initWithInfo:(NSDictionary *)commentInfo {
    self = [super init];
    if (self) {
        _text = [commentInfo valueForKeyPath:kTextKeyPath];
        _username = [commentInfo valueForKeyPath:kUsernameKeyPath];
        //checking if URL is entity of NSNull class
        NSString *userImageURLString = [commentInfo valueForKeyPath:kUserPhotoKeyPath];
        _userPhotoURLString = [userImageURLString isKindOfClass:[NSNull class]] ? nil : userImageURLString;
    }
    return self;
}

- (NSURL *)userPhotoURL {
    return [NSURL URLWithString:self.userPhotoURLString];
}

@end
