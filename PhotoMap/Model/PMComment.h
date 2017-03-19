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

@property (readonly, nonatomic, strong) NSString *text;
@property (readonly, nonatomic, strong) NSString *username;
@property (readonly, nonatomic, strong) NSURL *userPhotoURL;
@property (nonatomic, strong) UIImage *userPhoto;

- (instancetype)initWithInfo:(NSDictionary *)commentInfo;

@end
