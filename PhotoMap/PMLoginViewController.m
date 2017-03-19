//
//  PMLoginViewController.m
//  PhotoMap
//
//  Created by Александр on 22.12.16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

#import "PMLoginViewController.h"
#import "PMServerManager.h"

//model
#import "PMUser.h"
#import "PMAccessToken.h"

@interface PMLoginViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (copy, nonatomic) PMLoginCompletionBlock completionBlock;

@end

@implementation PMLoginViewController

- (instancetype)initWithCompletionBlock:(PMLoginCompletionBlock)completionBlock {
    
    self = [super init];
    if (self) {
        _completionBlock = completionBlock;
    }
    return self;
}

- (instancetype)init
{
    //designated initializer should be used instead
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Login";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                          target:self
                                                          action:@selector(actionCancel:)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
    
    self.webView = webView;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    //[self runTokenAuthentication];
    [self runCodeAuthentication];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    
    self.webView.delegate = nil;
}

#pragma mark - Authentication

- (void)runTokenAuthentication {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/"
                           "?client_id=%@&"
                           "redirect_uri=%@&"
                           "response_type=token", INSTAGRAM_CLIENT_ID, INSTAGRAM_REDIRECT_URI];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)runCodeAuthentication {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/"
                           "?client_id=%@&"
                           "redirect_uri=%@&"
                           "response_type=code", INSTAGRAM_CLIENT_ID, INSTAGRAM_REDIRECT_URI];
    
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
    NSRange tokenSearchRange = [requestURLString rangeOfString:@"access_token="];
    if (tokenSearchRange.location != NSNotFound) {
        
        NSString *accessTokenNumber = [requestURLString substringFromIndex:tokenSearchRange.location + tokenSearchRange.length];
        PMAccessToken *accessToken = [[PMAccessToken alloc] initWithNumber:accessTokenNumber];
        
        self.completionBlock(accessToken, nil);
        [self actionCancel:nil];
        return NO;
    }
    NSRange codeSearchRange = [requestURLString rangeOfString:@"code="];
    if (codeSearchRange.location != NSNotFound) {
        
        NSString *code = [requestURLString substringFromIndex:codeSearchRange.location + codeSearchRange.length];
        [[PMServerManager sharedManager] getAccessTokenWithCode:code
                                                      onSuccess:^(NSDictionary *authenticationInfo) {
                                                          
                                                          NSString *accessTokenNumber = [authenticationInfo objectForKey:@"access_token"];
                                                          PMAccessToken *accessToken = [[PMAccessToken alloc] initWithNumber:accessTokenNumber];
                                                          PMUser *user = [[PMUser alloc] initWithInfo:authenticationInfo[@"user"]];
                                                          self.completionBlock(accessToken, user);
                                                          [self actionCancel:nil];
                                                          
                                                      } onFailure:^(NSError *error) {
                                                          NSLog(@"ERROR: %@", [error userInfo]);
                                                      }];
        return NO;
    }
    return YES;
}

@end
