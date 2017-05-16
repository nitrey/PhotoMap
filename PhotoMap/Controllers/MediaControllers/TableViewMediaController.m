//
//  PostsTableVC.m
//  PhotoMap
//
//  Created by Alexandr on 19.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "TableViewMediaController.h"

//model
#import "PMPost.h"
#import "PMUser.h"

//VSs
#import "SinglePostVC.h"
#import "CommentsVC.h"

//helpers
#import "PMServerManager.h"
#import "UIView+SuperCell.h"

@interface TableViewMediaController () <TableViewDDMDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSString *nextMaxID;
@property (assign, nonatomic) CGPoint lastContentOffset;
@property (assign, nonatomic) BOOL reloadingTableView;

@end

@implementation TableViewMediaController

@synthesize user = _user;

static CGFloat kActivityIndicatorOffsetY = -20.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPostsTableVC];
    [self getMedia];
}

- (void)setupPostsTableVC {
    [self setupTableView];
    [self setupActivityIndicator];
    [self setupDataManager];
    self.lastContentOffset = CGPointZero;
}

- (void)setUser:(PMUser *)user {
    _user = user;
    if ([self.dataManager.dataArray count]) {
        [[PMServerManager sharedManager].currentUser addPosts:self.dataManager.dataArray];
    }
}

- (void)setupDataManager {
    self.dataManager = [[TableViewDDM alloc] init];
    self.dataManager.delegate = self;
    self.tableView.delegate = self.dataManager;
    self.tableView.dataSource = self.dataManager;
}

- (void)setupTableView {
    self.reloadingTableView = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self
                       action:@selector(reloadPostsInfo)
             forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
}

- (void)setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicator.color = [UIColor lightGrayColor];
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.activityIndicator];
    [[self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:kActivityIndicatorOffsetY] setActive:YES];
    [self.activityIndicator startAnimating];
}

#pragma mark - Actions

- (void)reloadPostsInfo {
    self.reloadingTableView = YES;
    self.lastContentOffset = CGPointZero;
    self.nextMaxID = @"0";
    [self getMedia];
}

- (IBAction)actionShowComments:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"No comments"]) {
        return;
    }
    UITableViewCell *cell = [sender superViewCell];
    NSInteger index = [self.tableView indexPathForCell:cell].section;
    PMPost *post = [self.dataManager postAtIndex:index];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CommentsVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"CommentsVC"];
    vc.mediaID = post.mediaID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - API

- (void)getMedia {
    //ABSTRACT METHOD, SHOULD BE OVERRIDDEN BY SUBCLASSES
}

- (void)updateDataManagerWithArray:(NSArray *)array {
    NSArray *initialArray = self.reloadingTableView ? nil : self.dataManager.dataArray;
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:initialArray];
    NSUInteger objIndex = [self.dataManager.dataArray count];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (PMPost *post in array) {
        [newArray addObject:post];
        [[PMServerManager sharedManager].currentUser addPost:post];
        [indexSet addIndex:objIndex];
        objIndex += 1;
    }
    self.dataManager.dataArray = [newArray copy];
    [self performBlockOnMainQueue:^{
        [self.tableView.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
        self.dataManager.updating = NO;
        if ([indexSet count] && [indexSet count] < [self.dataManager.dataArray count]) {
            [self.tableView beginUpdates];
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        } else {
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - <DDMDelegate>

- (void)needsShowPost:(PMPost *)post ddm:(TableViewDDM *)ddm {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SinglePostVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"SinglePostVC"];
    vc.post = post;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)needsReloadTableView:(DataDisplayManager *)ddm {
    [self performSelectorOnMainThread:@selector(reloadData) withObject:self.tableView waitUntilDone:NO];
}

- (void)ddmDidScrollToBottom:(DataDisplayManager *)ddm {
    [self getMedia];
}

- (void)ddmWillStopScrolling:(DataDisplayManager *)ddm targetContentOffset:(CGPoint)targetOffset {
    self.lastContentOffset = targetOffset;
}

@end
