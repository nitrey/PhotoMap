//
//  PostHeaderCell.h
//  PhotoMap
//
//  Created by Александр on 04.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PostCell.h"

@interface PostHeaderCell : PostCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (strong, nonatomic) NSURL *posterImageURL;

- (void)setNickname:(NSString *)nickname andLocation:(NSString *)location;

@end
