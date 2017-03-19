//
//  PostsCollectionVC.h
//  PhotoMap
//
//  Created by Александр on 18.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "AbstractPostsViewController.h"
#import "CollectionViewDDM.h"

@protocol CollectionViewDDMDelegate;

@interface PostsCollectionVC : AbstractPostsViewController <CollectionViewDDMDelegate>

@end
