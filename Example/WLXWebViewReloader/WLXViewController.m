//
//  WLXViewController.m
//  WebViewReloader
//
//  Created by Guido Marucci Blas on 08/26/2014.
//  Copyright (c) 2014 Guido Marucci Blas. All rights reserved.
//

#import "WLXViewController.h"
#import <WLXWebViewReloader/WKWebView+WLXWebViewReloader.h>

@import WebKit;

@interface WLXViewController ()<WKNavigationDelegate, WLXWebViewReloaderDelegate>

@property (nonatomic) WKWebView * webView;
@property (nonatomic) WLXWebViewReloader * webViewReloader;

@end

@implementation WLXViewController

- (void)loadView {
    [super loadView];
    self.webView = [[WKWebView alloc] init];
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    self.webView.reloaderIdentifier = @"WebViewSource";
    self.webView.reloaderDelegate = self;
    [self.webView reloadOnFileChangeThatMatches:@".*\\.html"];
#endif
    
    NSURL * URL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html" subdirectory:@"WebViewSource"];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    self.webView.navigationDelegate = self;
    [self.webView loadLocalRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.webView startListeningToFileChanges];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.webView stopListeningToFileChanges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKNavigationDelegate methods

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)webView:(WKWebView *)webView
didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"Finish navigation %@", navigation);
}

#pragma mark - WLXWebViewReloaderDelegate methods

- (void)webViewReloader:(WLXWebViewReloader *)reloader didFailToConnect:(NSError *)error {
    NSLog(@"Error connecting reloader: %@", error);
}

- (void)webViewReloaderDidConnect:(WLXWebViewReloader *)reloader {
    NSLog(@"Reloader connected!");
}

- (void)webViewReloader:(WLXWebViewReloader *)reloader willReloadWebView:(WKWebView *)webView {
    NSLog(@"Web view about to be reloaded");
}

- (void)webViewReloader:(WLXWebViewReloader *)reloader didReloadWebView:(WKWebView *)webView {
    NSLog(@"Web view reloaded!");
}

@end