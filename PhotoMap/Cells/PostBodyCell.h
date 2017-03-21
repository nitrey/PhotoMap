//
//  PostBodyCell.h
//  PhotoMap
//
//  Created by Александр on 03.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCell.h"

@interface PostBodyCell : PostCell

@property (weak, nonatomic) IBOutlet UIImageView *bodyView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSURL *postPhotoURL;

@end
