//
//  PostMappingOperation.h
//  PhotoMap
//
//  Created by Александр on 03.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostMappingOperation : NSOperation

@property (strong, nonatomic) NSDictionary *input;
@property (strong, nonatomic) NSArray *result; // of PMPosts

- (instancetype)initWithDictionary:(NSDictionary *)inputDictionary;

@end
