//
//  TextTagDecorator.m
//  PhotoMap
//
//  Created by Alexandr on 10.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "TextTagDecorator.h"
#import <UIKit/UIKit.h>

@implementation TextTagDecorator

+ (instancetype)sharedDecorator {
    static TextTagDecorator *decorator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        decorator = [[TextTagDecorator alloc] init];
    });
    return decorator;
}

- (NSAttributedString *)decorateTagsInText:(NSString *)inputString {
    
    NSError *error = nil;
    NSRegularExpression *tagsRegExpression = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)"
                                                                                       options:0
                                                                                         error:&error];
    NSRegularExpression *namesRegExpresssion = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)"
                                                                                         options:0
                                                                                           error:&error];
    NSUInteger stringLength = [inputString length];
    NSArray *tagsMatches = [tagsRegExpression matchesInString:inputString
                                                      options:0
                                                        range:NSMakeRange(0, stringLength)];
    NSArray *namesMatches = [namesRegExpresssion matchesInString:inputString
                                                         options:0 range:NSMakeRange(0, stringLength)];
    NSArray *allMatches = [tagsMatches arrayByAddingObjectsFromArray:namesMatches];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:inputString];
    
    for (NSTextCheckingResult *match in allMatches) {
        NSRange wordRange = [match rangeAtIndex:0];
        UIColor *tagsColor = [UIColor blueColor];
        [attributedString addAttribute:NSForegroundColorAttributeName value:tagsColor range:wordRange];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:wordRange];
    }
    return [attributedString copy];
}

@end
