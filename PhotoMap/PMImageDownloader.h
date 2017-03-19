//
//  PMImageDownloader.h
//  PhotoMap
//
//  Created by Александр on 18.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PMImageDownloader : NSObject

+ (instancetype)sharedDownloader;
- (void)downloadImage:(NSURL *)imageURL completion:(void(^)(UIImage *image))completionBlock;

//completion block will be called on main queue

@end
