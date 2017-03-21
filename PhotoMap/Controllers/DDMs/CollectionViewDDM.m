//
//  CollectionViewDDM.m
//  PhotoMap
//
//  Created by Александр on 18.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "CollectionViewDDM.h"
#import "CollectionPhotoCell.h"

//model
#import "PMPost.h"

//helpers
#import "PMImageDownloader.h"

@interface CollectionViewDDM ()

@property (strong, nonatomic)  UICollectionView *collectionView;
@property (weak, nonatomic) PMImageDownloader *imageDownloader;

@end

@implementation CollectionViewDDM

static NSUInteger ITEMS_IN_ROW = 3;
static UIEdgeInsets sectionInsets = {1.0, 0.0, 1.0, 0.0};
static CGFloat interItemSpacing = 1.0;

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _imageDownloader = [PMImageDownloader sharedDownloader];
    }
    return self;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat paddingSpace = sectionInsets.top * (ITEMS_IN_ROW - 1);
    CGFloat availableWidth = collectionView.bounds.size.width - paddingSpace;
    CGFloat unitWidth = availableWidth / ITEMS_IN_ROW;
    return CGSizeMake(unitWidth, unitWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return sectionInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return interItemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return interItemSpacing;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.delegate needsShowPost:self.dataArray[indexPath.row]];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CollectionPhotoCell";
    static UIImage *postPlaceholder;
    if (!postPlaceholder) {
        postPlaceholder = [UIImage imageNamed:@"photoPlaceholder.jpg"];
    }
    CollectionPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                          forIndexPath:indexPath];
    cell.imageView.image = postPlaceholder;
    [cell.activityIndicator startAnimating];
    
    PMPost *post = self.dataArray[indexPath.row];
    cell.postPhotoThumbnailURL = post.postPhotoThumbnailURL;
    
    if (post.postPhotoThumbnailImage) {
        [cell.activityIndicator stopAnimating];
        cell.imageView.image = post.postPhotoThumbnailImage;
        return cell;
    }
    [self.imageDownloader downloadImage:post.postPhotoThumbnailURL completion:^(UIImage *image) {
        CollectionPhotoCell *updateCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                                    forIndexPath:indexPath];
        if (!updateCell) {
            return;
        }
        if (![cell.postPhotoThumbnailURL isEqual:post.postPhotoThumbnailURL]) {
            return;
        }
        post.postPhotoThumbnailImage = image;
        [cell.activityIndicator stopAnimating];
        [UIView transitionWithView:cell.imageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            cell.imageView.image = image;
                        } completion:NULL];
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
