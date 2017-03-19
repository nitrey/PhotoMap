//
//  NSNull+JSON.m
//  PhotoMap
//
//  Created by Александр on 04.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "NSNull+JSON.h"

@implementation NSNull (JSON)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (NSRange)rangeOfCharacterFromSet:(NSSet *)searchSet { return NSMakeRange(NSNotFound, NSNotFound); }

- (BOOL)isEqualToString:(NSString *)aString { return NO; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

@end
