//
//  PostMappingOperation.m
//  PhotoMap
//
//  Created by Александр on 03.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PostMappingOperation.h"
#import "PMPost.h"
#import "AAUtils.h"

@implementation PostMappingOperation

- (instancetype)initWithDictionary:(NSDictionary *)inputDictionary {
    self = [super init];
    if (self != nil) {
        _input = inputDictionary;
    }
    return self;
}

- (void)main {
    NSArray *postsInfoArray = self.input[@"data"];
    NSMutableArray *postsArray = [NSMutableArray array];
    for (NSDictionary *postInfo in postsInfoArray) {
        PMPost *post = [[PMPost alloc] initWithPostInfo:postInfo];
        [postsArray addObject:post];
    }
    self.result = [postsArray copy];
}

@end
