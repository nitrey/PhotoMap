//
//  PostFooterCell.m
//  PhotoMap
//
//  Created by Александр on 04.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PostFooterCell.h"

@interface PostFooterCell ()

@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *showCommentsButton;

@end

@implementation PostFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellType = PostCellFooter;
}

- (void)setLikesCount:(NSUInteger)likes andCommentsCount:(NSUInteger)comments {
    
    self.likesCountLabel.text = [NSString stringWithFormat:@"%ld likes", likes];
    [self.showCommentsButton setTitle:comments ?
     [NSString stringWithFormat:@"Show all %ld comments", comments] : @"No comments"
                             forState:UIControlStateNormal];
}

@end
