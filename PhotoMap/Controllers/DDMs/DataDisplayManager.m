//
//  DataDisplayManager.m
//  PhotoMap
//
//  Created by Александр on 04.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "DataDisplayManager.h"

@implementation DataDisplayManager

- (instancetype)initWithDataArray:(NSArray *)array {
    self = [super init];
    if (self != nil) {
        _dataArray = array;
    }
    return self;
}

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
