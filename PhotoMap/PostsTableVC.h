//
//  PostsTableVC.h
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "AbstractPostsViewController.h"
#import "TableViewDDM.h"

typedef void(^requestCompletionBlock)(NSDictionary *resultInfo);

@interface PostsTableVC : AbstractPostsViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TableViewDDM *dataManager;

@end
