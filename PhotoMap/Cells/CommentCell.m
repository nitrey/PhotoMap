//
//  CommentCell.m
//  PhotoMap
//
//  Created by Alexandr on 10.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "CommentCell.h"

//Model
#import "PMComment.h"

//Helpers
#import "TextTagDecorator.h"
#import "PMImageDownloader.h"

@implementation CommentCell

CGFloat cellCommentFontSize = 15.0;

- (void)configureWithComment:(PMComment *)comment {
    
    self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width / 2.0;
    NSAttributedString *usernameText = [self boldStringFromString:comment.username];
    NSAttributedString *separatorString = [[NSAttributedString alloc] initWithString:@" "];
    NSAttributedString *commentText = [[TextTagDecorator sharedDecorator] decorateTagsInText:comment.text fontSize:cellCommentFontSize];
    NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] init];
    [resultText appendAttributedString:usernameText];
    [resultText appendAttributedString:separatorString];
    [resultText appendAttributedString:commentText];
    self.commentTextLabel.attributedText = [resultText copy];
    
    if (comment.userPhotoURL) {
        [[PMImageDownloader sharedDownloader] downloadImage:comment.userPhotoURL
                                                 completion:^(UIImage *image) {
                                                     self.userImageView.image = image;
                                                 }];
    }
}

- (CGFloat)commentLabelWidth {
    return self.commentTextLabel.bounds.size.width;
}

- (NSAttributedString *)commentText {
    return self.commentTextLabel.attributedText;
}
                                    
- (NSAttributedString *)boldStringFromString:(NSString *)string {
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:string];
    UIFont *font = [UIFont boldSystemFontOfSize:cellCommentFontSize];
    [resultString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [resultString length])];
    return [resultString copy];
}



@end
