//
//  TableViewDDM.h
//  PhotoMap
//
//  Created by Александр on 03.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDisplayManager.h"

@class TableViewDDM, PMPost;

@protocol TableViewDDMDelegate <NSObject>

@optional

- (void)needsReloadTableView:(TableViewDDM *)ddm;
- (void)needsShowPost:(PMPost *)post ddm:(TableViewDDM *)ddm;
- (void)ddmDidScrollToBottom:(TableViewDDM *)ddm;
- (void)ddmWillStopScrolling:(TableViewDDM *)ddm targetContentOffset:(CGPoint)targetOffset;

@end

@interface TableViewDDM : DataDisplayManager <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <TableViewDDMDelegate> delegate;
@property (assign, nonatomic, getter=isUpdating) BOOL updating;

- (PMPost *)postAtIndex:(NSInteger)index;

@end
