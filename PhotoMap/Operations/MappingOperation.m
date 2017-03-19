//
//  MappingOperation.m
//  PhotoMap
//
//  Created by Александр on 31.01.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "MappingOperation.h"
#import "PMUser.h"

@implementation MappingOperation

- (void)main {
    if (self.input == nil) {
        [self cancel];
    }
    NSDictionary *userInfo = self.input[@"data"];
    self.result = [[PMUser alloc] initWithInfo:userInfo];
}

@end
