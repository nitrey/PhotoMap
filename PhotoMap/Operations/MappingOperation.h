//
//  MappingOperation.h
//  PhotoMap
//
//  Created by Александр on 31.01.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMUser;

@interface MappingOperation : NSOperation

@property (strong, nonatomic) NSDictionary *input;
@property (strong, nonatomic) PMUser *user;

@end
