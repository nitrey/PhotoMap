//
//  CollectionViewDDM.h
//  PhotoMap
//
//  Created by Александр on 18.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "DataDisplayManager.h"

@class PMPost;

@protocol CollectionViewDDMDelegate <NSObject>

@required
- (void)needsShowPost:(PMPost *)post;

@end

@interface CollectionViewDDM : DataDisplayManager <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) id delegate;

@end
