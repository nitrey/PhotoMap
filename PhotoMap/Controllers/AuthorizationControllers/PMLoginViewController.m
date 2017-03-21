//
//  PMLoginViewController.m
//  PhotoMap
//
//  Created by Александр on 22.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "PMLoginViewController.h"
#import "AAUtils.h"

//API
#import "InstagramAPI.h"
#import "PMServerManager.h"
#import "PMAccessToken.h"

//model
#import "PMUser.h"

NSString * const LoginSuccessNotificationName = @"com.nitrey.LoginSuccessNotificationName";
NSString * const LoginErrorNotificationName = @"com.nitrey.LoginErrorNotificationName";

@interface PMLoginViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation PMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPMLoginViewController];
    [self runUserAuthorization];
}

- (void)setupPMLoginViewController {
    self.navigationItem.title = @"Login";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(actionCancel:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    self.webView = [[UIWebView alloc] initWithFrame:rect];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    self.webView.delegate = nil;
}

#pragma mark - Authentication

- (void)runUserAuthorization {
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/"
                           "?client_id=%@&"
                           "redirect_uri=%@&"
                           "response_type=%@",
                           kInstagramClientID,
                           kInstagramRedirectURI,
                           @"code"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - Actions

- (void)actionCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestURLString = [[request URL] absoluteString];
    NSRange codeSearchRange = [requestURLString rangeOfString:@"code="];
    if (codeSearchRange.location != NSNotFound) {
        NSString *code = [requestURLString substringFromIndex:codeSearchRange.location + codeSearchRange.length];
        __weak typeof(self) weakSelf = self;
        [[PMServerManager sharedManager] getAccessTokenWithCode:code
                                                      onSuccess:^{
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotificationName object:nil];
                                                          [weakSelf actionCancel:nil];
                                                      } onFailure:^(NSError *error) {
                                                          AALog(@"ERROR: %@", [error userInfo]);
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:LoginErrorNotificationName object:nil];
                                                          [weakSelf actionCancel:nil];
                                                      }];
        return NO;
    }
    return YES;
}

@end
