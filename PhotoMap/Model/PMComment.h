//
//  PMComment.h
//  PhotoMap
//
//  Created by Alexandr on 10.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface PMComment : NSObject

@property (readonly, strong, nonatomic) NSString *text;
@property (readonly, strong, nonatomic) NSString *username;
@property (readonly, strong, nonatomic) NSURL *userPhotoURL;
@property (strong, nonatomic) UIImage *userPhoto;

- (instancetype)initWithInfo:(NSDictionary *)commentInfo;

@end
