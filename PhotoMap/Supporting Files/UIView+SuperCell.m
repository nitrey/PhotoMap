//
//  UIView+SuperCell.m
//  PhotoMap
//
//  Created by Alexandr on 18.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "UIView+SuperCell.h"

@implementation UIView (SuperCell)

- (nullable UITableViewCell *)superViewCell {
    UIView *superview = self.superview;
    if (superview == nil) {
        return nil;
    }
    if ([superview isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)superview;
    } else {
        return [self.superview superViewCell];
    }
}

@end
