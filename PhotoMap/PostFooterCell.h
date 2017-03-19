//
//  PostFooterCell.h
//  PhotoMap
//
//  Created by Александр on 04.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PostCell.h"

@interface PostFooterCell : PostCell

- (void)setLikesCount:(NSUInteger)likes andCommentsCount:(NSUInteger)comments;

@end
