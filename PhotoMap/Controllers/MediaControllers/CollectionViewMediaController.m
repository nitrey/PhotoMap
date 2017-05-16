//
//  PostsCollectionVC.m
//  PhotoMap
//
//  Created by Александр on 18.02.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//
#import "CollectionViewMediaController.h"

//model
#import "PMUser.h"

//API
#import "PMServerManager.h"
#import "PostMappingOperation.h"

//helpers
#import "AAUtils.h"

//Controllers
#import "SinglePostVC.h"

static NSInteger POSTS_IN_REQUEST = 20;
static NSString * kNextMaxIDKeyPath = @"pagination.next_max_id";

@interface CollectionViewMediaController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) CollectionViewDDM *dataManager;
@property (assign, nonatomic) CGPoint lastContentOffset;
@property (strong, nonatomic) NSString *nextMaxID;

@end

@implementation CollectionViewMediaController

@synthesize user = _user;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.serverManager = [PMServerManager sharedManager];
    [self setupPostsCollectionVC];
    [self getMedia];
}

- (void)setupPostsCollectionVC {
    self.dataManager = [[CollectionViewDDM alloc] init];
    self.dataManager.delegate = self;
    self.collectionView.dataSource = self.dataManager;
    self.collectionView.delegate = self.dataManager;
    self.queue = [[NSOperationQueue alloc] init];
}

- (void)reloadPostsInfo {
    self.dataManager.dataArray = [NSMutableArray array];
    self.lastContentOffset = CGPointZero;
    self.nextMaxID = @"0";
    [self getMedia];
}

- (void)setUser:(PMUser *)user {
    _user = user;
    if ([self.dataManager.dataArray count]) {
        [user addPosts:self.dataManager.dataArray];
    }
}

#pragma mark - API

- (void)getMedia {
    __weak CollectionViewMediaController *weakSelf = self;
    [self.serverManager getCurrentUserRecentMediaCount:@(POSTS_IN_REQUEST)
                                                               minID:@"0"
                                                               maxID:self.nextMaxID ? self.nextMaxID : @"0"
                                                           onSuccess:^(NSDictionary *responseObject) {
                                                               
                                                               AALog(@"actionGetCurrentUserMedia SUCCESS");
                                                               weakSelf.nextMaxID = [responseObject valueForKeyPath:kNextMaxIDKeyPath];
                                                               [weakSelf mapResponseObject:responseObject];
                                                               
                                                           } onFailure:^(NSError *error) {
                                                               AALog(@"actionGetCurrentUserMedia FAILURE");
                                                           }];
}

- (void)updateDataManagerWithArray:(NSArray *)array {
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.dataManager.dataArray];
    [newArray addObjectsFromArray:array];
    [self.user addPosts:array];
    self.dataManager.dataArray = [newArray copy];
    [self performBlockOnMainQueue:^{
        [self.collectionView reloadData];
    }];
}

#pragma mark - <CollectionViewDDMDelegate>

- (void)needsShowPost:(PMPost *)post {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SinglePostVC *vc = (SinglePostVC *)[storyboard instantiateViewControllerWithIdentifier:@"SinglePostVC"];
    vc.post = post;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
