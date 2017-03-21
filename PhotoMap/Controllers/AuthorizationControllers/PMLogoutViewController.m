//
//  PMLogoutViewController.m
//  PhotoMap
//
//  Created by Alexandr on 21.03.17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

#import "PMLogoutViewController.h"
#import "PMServerManager.h"

NSString * const LogoutSuccessNotificationName = @"com.nitrey.LogoutSuccessNotificationName";
NSString * const LogoutErrorNotificationName = @"com.nitrey.LogoutErrorNotificationName";

@interface PMLogoutViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation PMLogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPMLogoutViewController];
    [self logout];
}

- (void)setupPMLogoutViewController {
    self.navigationItem.title = @"Logout";
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

- (void)dealloc {
    self.webView.delegate = nil;
}

- (void)logout {
    NSString *urlString = @"https://instagram.com/accounts/logout/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - <UIWebViewDelegate>

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotificationName object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutErrorNotificationName object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)actionCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
