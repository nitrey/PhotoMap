//
//  PMPostPinAnnotationView.m
//  PhotoMap
//
//  Created by Alexandr on 20.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PMPostPinAnnotationView.h"
#import "PMPost.h"

//helpers
#import "TextTagDecorator.h"
#import "PMImageDownloader.h"

@interface PMPostPinAnnotationView ()

@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation PMPostPinAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = YES;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52.0, 52.0)];
        self.leftCalloutAccessoryView = self.imageView;
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 24.0)];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.detailCalloutAccessoryView = self.descriptionLabel;
        self.rightCalloutAccessoryView = [self buttonForRightCalloutAccessoryView];
    }
    return self;
}

- (void)configureWithPost:(PMPost *)post {
    NSAttributedString *descriptionText = [[TextTagDecorator sharedDecorator] decorateTagsInText:post.postDescription fontSize:12.0];
    self.descriptionLabel.attributedText = [descriptionText length] ? descriptionText : [[NSAttributedString alloc] initWithString:@" "];
    if (post.postPhotoImage) {
        self.imageView.image = post.postPhotoImage;
    } else {
        [[PMImageDownloader sharedDownloader] downloadImage:post.postPhotoURL completion:^(UIImage *image) {
            self.imageView.image = image;
        }];
    }
}

- (UIButton *)buttonForRightCalloutAccessoryView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CGRectMake(0, 0, 44.0, 44.0);
    return button;
}

@end
