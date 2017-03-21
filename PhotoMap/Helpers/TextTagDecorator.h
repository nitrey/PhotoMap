//
//  TextTagDecorator.h
//  PhotoMap
//
//  Created by Alexandr on 10.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextTagDecorator : NSObject

+ (instancetype)sharedDecorator;
- (NSAttributedString *)decorateTagsInText:(NSString *)inputString fontSize:(CGFloat)fontSize;

@end
