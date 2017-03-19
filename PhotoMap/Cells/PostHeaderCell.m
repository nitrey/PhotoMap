//
//  PostHeaderCell.m
//  PhotoMap
//
//  Created by Александр on 04.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PostHeaderCell.h"

@interface PostHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation PostHeaderCell

- (void)setNickname:(NSString *)nickname andLocation:(NSString *)location {
    
    self.nicknameLabel.text = nickname;
    self.locationLabel.text = location ? location : @"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellType = PostCellHeader;
    self.posterImageView.layer.cornerRadius = CGRectGetWidth(self.posterImageView.bounds) / 2.0;
    self.posterImageView.clipsToBounds = YES;
}

@end
