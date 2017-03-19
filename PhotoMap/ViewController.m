//
//  ViewController.m
//  PhotoMap
//
//  Created by Александр on 21.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

//model
#import "PMUser.h"
#import "PMAccessToken.h"

//operations
#import "MappingOperation.h"

//controllers
#import "ViewController.h"
#import "PMLoginViewController.h"
#import "CurrentUserMediaVC.h"
#import "LikedMediaVC.h"
#import "PostsCollectionVC.h"
#import "MapViewController.h"

//helpers
#import "PMServerManager.h"
#import "PMImageDownloader.h"

//libraries
#import <AFNetworking/AFNetworking.h>

@interface ViewController () <MapAnnotationsDataSource>

@property (weak, nonatomic) IBOutlet UITextField *userIDField;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) PMServerManager *serverManager;
@property (weak, nonatomic) IBOutlet UILabel *postsCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UIView *headerStackView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIViewController *childVC;

@end

@implementation ViewController

CGFloat headerStackViewHeightConstant = 80.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
    [self actionGetCurrentUserInfo:nil];
    [self actionShowCurrentUserMediaInCollection:nil];
}

- (void)setupViewController {
    self.serverManager = [PMServerManager sharedManager];
    CGFloat offset = 10.0;
    CGFloat imageSide = ((CGRectGetWidth(self.view.bounds) - 2 * offset) / 5.0) + 2.0;
    CGRect rect = self.userImageView.frame;
    rect.size = CGSizeMake(imageSide, imageSide);
    self.userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.userImageView.heightAnchor constraintEqualToConstant:imageSide] setActive:YES];
    self.userImageView.frame = rect;
    self.userImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userImageView.layer.cornerRadius = imageSide / 2.0;
    self.userImageView.layer.borderWidth = 1.5;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSArray *countLabels = @[self.postsCount, self.followersCount, self.followingCount];
    for (UILabel *label in countLabels) {
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:infoLabel];
        
        [[infoLabel.centerXAnchor constraintEqualToAnchor:label.centerXAnchor] setActive:YES];
        [[infoLabel.centerYAnchor constraintEqualToAnchor:label.centerYAnchor constant:18.0] setActive:YES];
        
        infoLabel.font = [UIFont systemFontOfSize:12.0];
        infoLabel.textColor = [UIColor whiteColor];
        
        if ([label isEqual:self.postsCount]) {
            infoLabel.text = @"posts";
        } else if ([label isEqual:self.followersCount]) {
            infoLabel.text = @"followers";
        } else if ([label isEqual:self.followingCount]) {
            infoLabel.text = @"following";
        }
    }

    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                               target:self
                                                                               action:@selector(actionShowMapWithPosts)];
    self.navigationItem.rightBarButtonItems = @[mapButton];
    self.title = @"PhotoMap";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setUser:(PMUser *)user {
    if (![_user.username isEqualToString:user.username]) {
        AALog(@"New user! Username = %@", user.username);
        [self actionGetCurrentUserInfo:nil];
        
        [[PMImageDownloader sharedDownloader] downloadImage:[user pictureURL] completion:^(UIImage *image) {
            self.userImageView.image = image;
        }];
    }
    _user = user;
}

- (void)updateCounts {
    self.postsCount.text = [NSString stringWithFormat:@"%@", self.user.postsCount];
    self.followersCount.text = [NSString stringWithFormat:@"%@", self.user.followersCount];
    self.followingCount.text = [NSString stringWithFormat:@"%@", self.user.followingCount];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actons

- (IBAction)actionUserLogin:(UIButton *)sender {
    PMLoginViewController *loginVC = [[PMLoginViewController alloc] initWithCompletionBlock:^(PMAccessToken *token, PMUser *user) {
        self.serverManager.token = token;
        if (user != nil) {
            self.user = user;
        }
    }];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)actionShowMapWithPosts {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MapViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
    vc.dataSource = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionGetCurrentUserInfo:(UIButton *)sender {
    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self?access_token=%@", self.serverManager.token.number];
    
    __weak ViewController *weakSelf = self;
    
    [self.serverManager.sessionManager GET:requestString
                     parameters:nil
                       progress:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            AALog(@"SUCCESS");
                            AALog(@"RESPONSE OBJECT: %@", responseObject);
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                weakSelf.user = [[PMUser alloc] initWithInfo:responseObject[@"data"]];
                                if (weakSelf.childVC) {
                                    [(AbstractPostsViewController *)weakSelf.childVC setUser:weakSelf.user];
                                }
                                [weakSelf updateCounts];
                            });
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                            AALog(@"FAIL");
                        }];
}

- (IBAction)actionShowCurrentUserMediaInCollection:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PostsCollectionVC *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"PostsCollectionVC"];
    detailVC.user = self.user;
    
    [self addChildViewController:detailVC];
    CGRect rect = self.view.bounds;
    
    CGFloat topOffset = headerStackViewHeightConstant;
    rect.origin.y = topOffset;
    rect.size.height -= topOffset;
    detailVC.view.frame = rect;
    
    __weak ViewController *weakSelf = self;
    
    if (self.childVC != nil) {
        [self transitionFromViewController:self.childVC
                          toViewController:detailVC
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    [weakSelf.childVC removeFromParentViewController];
                                    weakSelf.childVC = detailVC;
                                }];
    } else {
        self.childVC = detailVC;
        [self.view addSubview:detailVC.view];
    }
    
}

- (IBAction)actionGetCurrentUserMedia:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CurrentUserMediaVC *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"CurrentUserMediaVC"];
    detailVC.user = self.user;
    
    [self addChildViewController:detailVC];
    CGRect rect = self.view.bounds;
    
    CGFloat topOffset = headerStackViewHeightConstant;
    rect.origin.y = topOffset;
    rect.size.height -= topOffset;
    detailVC.view.frame = rect;
    
    __weak ViewController *weakSelf = self;
    
    if (self.childVC != nil) {
        [self transitionFromViewController:self.childVC
                          toViewController:detailVC
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    [weakSelf.childVC removeFromParentViewController];
                                    weakSelf.childVC = detailVC;
                                }];
    } else {
        self.childVC = detailVC;
        [self.view addSubview:detailVC.view];
    }
}

- (IBAction)actionGetUsersLikedMedia:(UIButton *)sender {
    
    if ([self.childVC isKindOfClass:[LikedMediaVC class]]) {
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LikedMediaVC *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"LikedMediaVC"];
    
    [self addChildViewController:detailVC];
    CGRect rect = self.view.bounds;
    
    CGFloat topOffset = CGRectGetMaxY(self.headerStackView.frame);
    rect.origin.y = topOffset;
    rect.size.height -= topOffset;
    detailVC.view.frame = rect;
    [self.view addSubview:detailVC.view];
}

- (IBAction)actionGetUserInfo:(id)sender {
    
    NSString *userID = self.userIDField.text;
    
    if (userID) {
        [self.serverManager
         getUserInfo:userID
         onSuccess:^(NSDictionary *responseObject) {
             AALog(@"actionGetUserInfo SUCCESS");
         } onFailure:^(NSError *error) {
             AALog(@"actionGetUserInfo FAILURE");
         }];
    }
}

- (IBAction)actionGetUserMedia:(id)sender {
    
    NSString *userID = self.userIDField.text;
    
    if (userID) {
        [self.serverManager
         getUsersRecentMedia:userID
         OnSuccess:^(NSDictionary *responseObject) {
             AALog(@"actionGetUsersMedia SUCCESS");
         } onFailure:^(NSError *error) {
             AALog(@"actionGetUsersMedia FAILURE");
         }];
    }
}


#pragma mark - <MapAnnotationsDataSource>

- (NSArray *)objectsForAnnotations {
    
    return self.user.postsByUser;
}

@end
