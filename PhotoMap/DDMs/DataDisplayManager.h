//
//  DataDisplayManager.h
//  PhotoMap
//
//  Created by Александр on 04.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DataDisplayManager;

@interface DataDisplayManager : NSObject

@property (strong, nonatomic) NSArray *dataArray;

- (instancetype)initWithDataArray:(NSArray *)array;

@end
