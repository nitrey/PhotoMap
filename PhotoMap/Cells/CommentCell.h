//
//  CommentCell.h
//  PhotoMap
//
//  Created by Alexandr on 10.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMComment;

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;

- (void)configureWithComment:(PMComment *)comment;
- (NSAttributedString *)commentText;
- (CGFloat)commentLabelWidth;

@end
