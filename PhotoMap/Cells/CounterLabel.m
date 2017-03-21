//
//  CounterLabel.m
//  PhotoMap
//
//  Created by Alexandr on 21.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "CounterLabel.h"

static NSString * emptyStringText = @"   ";

@interface CounterLabel ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation CounterLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupActivityIndicatorView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupActivityIndicatorView];
}

- (void)setupActivityIndicatorView {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.hidesWhenStopped = YES;
    _activityIndicatorView = indicatorView;
    [self addSubview:indicatorView];
    indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [[indicatorView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
    [[indicatorView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (![text isEqualToString:emptyStringText]) {
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)startIndicator {
    self.text = emptyStringText;
    [self.activityIndicatorView startAnimating];
}

@end
