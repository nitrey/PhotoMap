//
//  TableViewDDM.m
//  PhotoMap
//
//  Created by Александр on 03.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "TableViewDDM.h"

//model
#import "PMPost.h"
#import "PMUser.h"

//cells
#import "PostHeaderCell.h"
#import "PostBodyCell.h"
#import "PostFooterCell.h"

//helpers
#import "PMImageDownloader.h"
#import "PMServerManager.h"
#import "AAUtils.h"

static NSString * headerCellIdentifier = @"PostHeaderCell";
static NSString * bodyCellIdentifier = @"PostBodyCell";
static NSString * footerCellIdentifier = @"PostFooterCell";
static NSString * thumbnailPlaceholderName = @"userThumbnailImagePlaceholder";
static NSString * postPhotoPlaceholderName = @"photoPlaceholder";

CGFloat headerCellHeight = 44.0;
CGFloat footerCellHeight = 52.0;

@interface TableViewDDM ()

@property (strong, nonatomic) NSOperationQueue *queue;
@property (weak, nonatomic) PMImageDownloader *imageDownloader;

@end

@implementation TableViewDDM

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _queue = [[NSOperationQueue alloc] init];
        _updating = NO;
        _imageDownloader = [PMImageDownloader sharedDownloader];
    }
    return self;
}

- (PMPost *)postAtIndex:(NSInteger)index {
    if (index >= 0 && index <= [self.dataArray count]) {
        return self.dataArray[index];
    } else {
        return nil;
    }
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPost *post = self.dataArray[indexPath.section];
    if (post == nil) {
        return nil;
    }
    PostCellType cellType = indexPath.row;
    switch (cellType) {
        case PostCellHeader: {
            PostHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier forIndexPath:indexPath];
            return [self configureHeaderCell:cell atIndexPath:indexPath inTableView:tableView];
            break;
        }
        case PostCellBody: {
            PostBodyCell *cell = [tableView dequeueReusableCellWithIdentifier:bodyCellIdentifier];
            return [self configureBodyCell:cell atIndexPath:indexPath inTableView:tableView];
            break;
        }
        case PostCellFooter: {
            PostFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:footerCellIdentifier forIndexPath:indexPath];
            [cell setLikesCount:post.likesCount andCommentsCount:post.commentsCount];
            return cell;
            break;
        }
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - Cells configuration

- (PostHeaderCell *)configureHeaderCell:(PostHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    PMPost *post = self.dataArray[indexPath.section];
    PMUser *user = [PMServerManager sharedManager].currentUser;
    [cell setNickname:user.username andLocation:post.location];
    if (user.userImage != nil) {
        cell.posterImageView.image = user.userImage;
    } else {
        __weak PostHeaderCell *weakCell = cell;
        cell.posterImageView.image = [UIImage imageNamed:thumbnailPlaceholderName];
        NSURL *userPhotoURL = user.pictureURL;
        [self.imageDownloader downloadImage:userPhotoURL
                                 completion:^(UIImage *image) {
                                     
                                     PostHeaderCell *updateCell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier
                                                                                                  forIndexPath:indexPath];
                                     if (updateCell == nil) {
                                         return;
                                     }
                                     [user updateUserImage:image];
                                     [UIView animateWithDuration:0.3
                                                           delay:0.0
                                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                                      animations:^{
                                                          weakCell.posterImageView.image = image;
                                                      } completion:NULL];
                                 }];
    }
    return cell;
}

- (PostBodyCell *)configureBodyCell:(PostBodyCell *)cell atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    PMPost *post = self.dataArray[indexPath.section];
    if (post == nil) {
        return nil;
    }
    cell.postPhotoURL = post.postPhotoURL;
    static UIImage *postPlaceholder;
    if (postPlaceholder == nil) {
        postPlaceholder = [UIImage imageNamed:postPhotoPlaceholderName];
    }
    if (post.postPhotoImage != nil) {
        [cell.activityIndicator stopAnimating];
        cell.bodyView.image = post.postPhotoImage;
    } else {
        cell.bodyView.image = postPlaceholder;
        [cell.activityIndicator startAnimating];
        __weak PostBodyCell *weakCell = cell;
        __weak typeof(self) weakSelf = self;
        [weakSelf.imageDownloader downloadImage:post.postPhotoURL completion:^(UIImage *image) {
            if (![cell.postPhotoURL isEqual:post.postPhotoURL]) {
                return;
            }
            post.postPhotoImage = image;
            [weakCell.activityIndicator stopAnimating];
            [UIView transitionWithView:weakCell.bodyView
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                weakCell.bodyView.image = image;
                                AALog(@"Photo for post %ld UPDATED", [tableView indexPathForCell:weakCell].section);
                            } completion:NULL];
        }];
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate needsShowPost:self.dataArray[indexPath.section] ddm:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCellType cellType = indexPath.row;
    switch (cellType) {
        case PostCellHeader: {
            return headerCellHeight;
            break;
        }
        case PostCellBody: {
            return CGRectGetWidth(tableView.bounds);
            break;
        }
        case PostCellFooter: {
            return footerCellHeight;
            break;
        }
    };
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffsetY = scrollView.contentOffset.y;
    CGFloat viewHeight = scrollView.bounds.size.height;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat showDelta = viewHeight * 3;
    
    if ((viewHeight + scrollOffsetY >= contentHeight - showDelta) && !self.isUpdating) {
        self.updating = YES;
        [self.delegate ddmDidScrollToBottom:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.delegate ddmWillStopScrolling:self targetContentOffset:*targetContentOffset];
}

@end
