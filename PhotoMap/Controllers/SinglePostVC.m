//
//  SinglePostVC.m
//  PhotoMap
//
//  Created by Alexandr on 09.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "SinglePostVC.h"

//model
#import "PMUser.h"
#import "PMPost.h"

//API
#import "PMImageDownloader.h"

//Controllers
#import "CommentsVC.h"

//Helpers
#import "AAUtils.h"
#import "TextTagDecorator.h"

static NSString * const kLikesLabelFormat = @"%lu likes";
static NSString * const kCommentsButtonFormat = @"%lu comments";

@interface SinglePostVC ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *postImageActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *photoDescriptionLabel;

@end

@implementation SinglePostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.title = @"Photo";
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width / 2.0;
    self.userImageView.clipsToBounds = YES;
    
    __weak typeof(self) weakSelf = self;
    PMPost *post = self.post;
    if (post) {
        self.userNameLabel.text = self.post.nickname;
        self.placeLabel.text = self.post.location ? self.post.location : @"";
        self.likesLabel.text = [NSString stringWithFormat:kLikesLabelFormat, (unsigned long)self.post.likesCount];
        [self.commentsButton setTitle:[NSString stringWithFormat:kCommentsButtonFormat, (unsigned long)self.post.commentsCount]
                             forState:UIControlStateNormal];
        self.photoDescriptionLabel.attributedText = [[TextTagDecorator sharedDecorator] decorateTagsInText:self.post.postDescription];
        
        if (self.post.userPhotoImage) {
            self.userImageView.image = [post userPhotoImage];
        } else {
            [[PMImageDownloader sharedDownloader] downloadImage:[post userPhotoURL] completion:^(UIImage *image) {
                weakSelf.userImageView.image = image;
                post.userPhotoImage = image;
            }];
        }
        
        if (post.postPhotoImage) {
            self.postImageView.image = [post postPhotoImage];
        } else {
            [[PMImageDownloader sharedDownloader] downloadImage:[post postPhotoURL] completion:^(UIImage *image) {
                weakSelf.postImageView.image = image;
                post.postPhotoImage = image;
            }];
        }
    }
}

#pragma mark - Actions

- (IBAction)actionShowComments:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    CommentsVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"CommentsVC"];
    vc.mediaID = self.post.mediaID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
