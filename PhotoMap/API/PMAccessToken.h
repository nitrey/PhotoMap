//
//  PMAccessToken.h
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMAccessToken : NSObject

@property (readonly, strong, nonatomic) NSString *number;

- (instancetype)initWithNumber:(NSString *)number;

@end
