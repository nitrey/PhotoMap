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

//controllers
#import "PMRootViewController.h"
#import "PMLoginViewController.h"
#import "PMLogoutViewController.h"
#import "CurrentUserTVMC.h"
#import "CollectionViewMediaController.h"
#import "MapViewController.h"
#import "MapViewDDM.h"

//views
#import "CounterLabel.h"

//helpers
#import "AAUtils.h"
#import "PMServerManager.h"
#import "PMImageDownloader.h"

//libraries
#import <AFNetworking/AFNetworking.h>

@interface PMRootViewController () 

@property (weak, nonatomic) IBOutlet UIView *headerStackView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet CounterLabel *postsCount;
@property (weak, nonatomic) IBOutlet CounterLabel *followersCount;
@property (weak, nonatomic) IBOutlet CounterLabel *followingCount;
@property (weak, nonatomic) IBOutlet UIButton *loginLogoutButton;
@property (weak, nonatomic) PMServerManager *serverManager;
@property (strong, nonatomic) UIViewController *childVC;

@end

@implementation PMRootViewController

CGFloat headerStackViewHeightConstant = 80.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
    [self actionGetCurrentUserInfo:nil];
}

- (void)setupViewController {
    self.serverManager = [PMServerManager sharedManager];
    [self subscribeToNotifications];
    [self setupUserImageView];
    [self setupNavigationBar];
    [self setupCountLabels];
}

- (void)setupUserImageView {
    CGFloat topSpacing = 4.0;
    CGFloat bottomSpacing = 4.0;
    CGFloat imageSideSize = headerStackViewHeightConstant - topSpacing - bottomSpacing;
    CGRect rect;
    rect.size = CGSizeMake(imageSideSize, imageSideSize);
    self.userImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.userImageView.heightAnchor constraintEqualToConstant:imageSideSize] setActive:YES];
    self.userImageView.frame = rect;
    self.userImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userImageView.layer.cornerRadius = imageSideSize / 2.0;
    self.userImageView.layer.borderWidth = 1.5;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setupCountLabels {
    NSArray *countLabels = @[self.postsCount, self.followersCount, self.followingCount];
    CGFloat verticalSpacing = headerStackViewHeightConstant / 4.0;
    CGFloat horizontalSpacing = (self.view.bounds.size.width - headerStackViewHeightConstant) / 4.0;
    for (NSInteger i = 0; i < [countLabels count]; i += 1) {
        CounterLabel *label = countLabels[i];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        CGFloat leadingSpace = horizontalSpacing * (i + 1);
        [[label.centerXAnchor constraintEqualToAnchor:self.userImageView.rightAnchor constant:leadingSpace] setActive:YES];
        [[label.centerYAnchor constraintEqualToAnchor:self.headerStackView.topAnchor constant:verticalSpacing] setActive:YES];
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
}

- (void)setupNavigationBar {
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
    self.navigationItem.rightBarButtonItem = mapButton;
    self.title = @"PhotoMap";
}

- (void)subscribeToNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(didLogin) name:LoginSuccessNotificationName object:nil];
    [nc addObserver:self selector:@selector(didFailToLogin) name:LoginErrorNotificationName object:nil];
    [nc addObserver:self selector:@selector(didLogout) name:LogoutSuccessNotificationName object:nil];
    [nc addObserver:self selector:@selector(didFailToLogout) name:LogoutErrorNotificationName object:nil];
    [nc addObserver:self selector:@selector(updateCurrentUser) name:NewUserNotificationName object:nil];
}

- (void)setUser:(PMUser *)user {
    if (![_user.username isEqualToString:user.username]) {
        _user = user;
        if (user != nil) {
            AALog(@"New user! Username = %@", user.username);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self actionGetCurrentUserInfo:nil];
            });
            [self updateCountLabels];
            [[PMImageDownloader sharedDownloader] downloadImage:user.pictureURL completion:^(UIImage *image) {
                self.userImageView.image = image;
            }];
        } else {
            AALog(@"User logged out");
            self.userImageView.image = [UIImage imageNamed:@"userimagePlaceholder"];
            [self resetCountLabel];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Handling notifications

- (void)didLogin {
    [self.loginLogoutButton setTitle:@"LOGOUT" forState:UIControlStateNormal];
}

- (void)didFailToLogin {
    [self.loginLogoutButton setTitle:@"LOGIN" forState:UIControlStateNormal];
}

- (void)didLogout {
    self.user = nil;
    [self.childVC.view removeFromSuperview];
    [self.childVC removeFromParentViewController];
    self.childVC = nil;
    [self.loginLogoutButton setTitle:@"LOGIN" forState:UIControlStateNormal];
}

- (void)didFailToLogout {
    [self.loginLogoutButton setTitle:@"LOGOUT" forState:UIControlStateNormal];
}

- (void)updateCurrentUser {
    self.user = self.serverManager.currentUser;
    [self.loginLogoutButton setTitle:@"LOGOUT" forState:UIControlStateNormal];
}

#pragma mark - Updating UI

- (void)updateCountLabels {
    [self updateCountLabel:self.postsCount withNumber:self.user.postsCount];
    [self updateCountLabel:self.followersCount withNumber:self.user.followersCount];
    [self updateCountLabel:self.followingCount withNumber:self.user.followingCount];
}

- (void)updateCountLabel:(CounterLabel *)label withNumber:(NSNumber *)count {
    if (count && ![count isKindOfClass:[NSNull class]]) {
        label.text = [NSString stringWithFormat:@"%@", count];
    } else {
        [label startIndicator];
    }
}

- (void)resetCountLabel {
    self.postsCount.text = @"0";
    self.followersCount.text = @"0";
    self.followingCount.text = @"0";
}

#pragma mark - Actons

- (IBAction)actionUserLoginLogout:(UIButton *)sender {
    UIViewController *vc;
    if (self.serverManager.currentUser) {
        vc = [[PMLogoutViewController alloc] init];
    } else {
        vc = [[PMLoginViewController alloc] init];
    }
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)actionShowMapWithPosts {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MapViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionGetCurrentUserInfo:(UIButton *)sender {
    __weak PMRootViewController *weakSelf = self;
    [self.serverManager getCurrentUserInfoOnSuccess:^(NSDictionary *responseObject) {
                                        AALog(@"actionGetCurrentUserInfo SUCCESS");
                                        AALog(@"RESPONSE OBJECT: %@", responseObject);
                                        [weakSelf performBlockOnMainQueue:^{
                                            if (weakSelf.childVC) {
                                                [(MediaViewController *)weakSelf.childVC setUser:weakSelf.serverManager.currentUser];
                                            }
                                            [weakSelf actionShowCurrentUserMediaInCollection:nil];
                                            [weakSelf updateCountLabels];
                                        }];
                                    }
                                        onFailure:^(NSError *error) {
                                            AALog(@"actionGetCurrentUserInfo FAILURE");
                                            AALog(@"ERROR: %@", error);
                                    }];
}

- (IBAction)actionShowCurrentUserMediaInCollection:(id)sender {
    if ([self.childVC isKindOfClass:[CollectionViewMediaController class]] || [PMServerManager sharedManager].currentUser == nil) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CollectionViewMediaController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"CollectionViewMediaController"];
    [self addChildViewController:detailVC];
    CGRect rect = self.view.bounds;
    CGFloat topOffset = headerStackViewHeightConstant;
    rect.origin.y = topOffset;
    rect.size.height -= topOffset;
    detailVC.view.frame = rect;
    
    __weak typeof(self) weakSelf = self;
    if (self.childVC != nil) {
        [self transitionFromViewController:self.childVC
                          toViewController:detailVC
                                  duration:1.0
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:nil
                                completion:^(BOOL finished) {
                                    [weakSelf.childVC.view removeFromSuperview];
                                    [weakSelf.childVC removeFromParentViewController];
                                    weakSelf.childVC = detailVC;
                                }];
    } else {
        self.childVC = detailVC;
        [self.view addSubview:detailVC.view];
    }
}

- (IBAction)actionGetCurrentUserMedia:(UIButton *)sender {
    if ([self.childVC isKindOfClass:[CurrentUserTVMC class]] || [PMServerManager sharedManager].currentUser == nil) {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CurrentUserTVMC *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"CurrentUserTVMC"];
    detailVC.user = [PMServerManager sharedManager].currentUser;
    
    [self addChildViewController:detailVC];
    CGRect rect = self.view.bounds;
    CGFloat topOffset = headerStackViewHeightConstant;
    rect.origin.y = topOffset;
    rect.size.height -= topOffset;
    detailVC.view.frame = rect;
    
    __weak PMRootViewController *weakSelf = self;
    if (self.childVC != nil) {
        [self transitionFromViewController:self.childVC
                          toViewController:detailVC
                                  duration:0.8
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:nil
                                completion:^(BOOL finished) {
                                    [weakSelf.childVC removeFromParentViewController];
                                    weakSelf.childVC = detailVC;
                                }];
    } else {
        self.childVC = detailVC;
        [self.view addSubview:detailVC.view];
    }
}

#pragma mark - Support methods

- (void)performBlockOnMainQueue:(void(^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

@end
