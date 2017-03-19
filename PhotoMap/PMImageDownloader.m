//
//  PMImageDownloader.m
//  PhotoMap
//
//  Created by Александр on 18.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PMImageDownloader.h"

@implementation PMImageDownloader

+ (instancetype)sharedDownloader {
    
    static PMImageDownloader *downloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[PMImageDownloader alloc] init];
    });
    return downloader;
}

- (void)downloadImage:(NSURL *)imageURL completion:(void(^)(UIImage *image))completionBlock {
    
    NSURLSessionTask *task =
        [[NSURLSession sharedSession] downloadTaskWithURL:imageURL
                                        completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            if (location == nil) {
                                                return;
                                            }
                                            UIImage *newImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                            if (newImage == nil) {
                                                return;
                                            }
                                            if ([NSThread isMainThread]) {
                                                completionBlock(newImage);
                                            } else {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    completionBlock(newImage);
                                                });
                                            }
                                        }];
    [task resume];
}

@end
