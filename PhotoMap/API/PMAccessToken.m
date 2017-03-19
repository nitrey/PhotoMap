//
//  PMAccessToken.m
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "PMAccessToken.h"

@implementation PMAccessToken

- (instancetype)initWithNumber:(NSString *)number {
    
    self = [super init];
    if (self) {
        self.number = number;
    }
    return self;
}

@end
