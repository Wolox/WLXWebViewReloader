//
//  WebViewReloader.m
//  WebViewReloader
//
//  Created by Guido Marucci Blas on 8/25/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import "WLXWebViewReloader.h"

static NSString * const kSrcChangeHandlerName = @"srcChangeHandler";

static NSString * const kConnectedHandlerName = @"connectedHandler";

static NSString * const kConnectionErrorHandlerName = @"connectionErrorHandler";

static NSString * const kPListKey = @"WLXWebViewReloader";

static NSURL * serverURL;

@interface WLXWebViewReloader ()<WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic) WKWebView * socketIOWebView;
@property (nonatomic, getter=isConnected) BOOL connected;

@end

@implementation WLXWebViewReloader

+ (void)initialize {
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * defaultServerURL = infoDictionary[kPListKey][@"DefaultServerURL"];
    if (defaultServerURL == nil || [defaultServerURL isEqualToString:@""]) {
        defaultServerURL = @"http://localhost:4040";
    }
    serverURL = [NSURL URLWithString:defaultServerURL];
}

+ (NSURL *)defaultServerURL {
    return serverURL;
}

+ (void)setDefaultServerURL:(NSURL *)aServerURL {
    serverURL = aServerURL;
}

+ (instancetype)reloaderWithWebViewIdentifier:(NSString *)webViewIdentifier {
    return [[WLXWebViewReloader alloc] initWithServerURL:[WLXWebViewReloader defaultServerURL]
                                       webViewIdentifier:webViewIdentifier
                                              andWebView:nil];
}

- (instancetype)initWithServerURL:(NSURL *)URL
                webViewIdentifier:(NSString *)webViewIdentifier
                       andWebView:(WKWebView *)webView {
    self = [super init];
    if (self) {
        _serverURL = URL;
        _webView = webView;
        _webViewIdentifier = webViewIdentifier;
        _notifierURL = [self.serverURL URLByAppendingPathComponent:_webViewIdentifier];
        _contentURL = [_notifierURL URLByAppendingPathComponent:@""];
        _connected = NO;
    }
    return self;
}

- (void)connect {
    if (self.connected) {
        return;
    }
    self.socketIOWebView = [self newSocketIOWebView];
    [self loadSocketIOWebView];
}

- (void)disconnect {
    [self.socketIOWebView.configuration.userContentController removeAllUserScripts];
    self.socketIOWebView = nil;
    self.connected = NO;
}

#pragma mark - WKScriptMesssageHandler delegate methods

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:kSrcChangeHandlerName]) {
        [self srcChangeHandler];
    }
    if ([message.name isEqualToString:kConnectedHandlerName]) {
        [self connectedHandler];
    }
    if ([message.name isEqualToString:kConnectionErrorHandlerName]) {
        [self connectionErrorHandler];
    }
}

#pragma mark - WKNavigationDelegate delegate methods

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webViewReloader:didFailToConnect:)]) {
        [self.delegate webViewReloader:self didFailToConnect:nil];
    }
}

- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webViewReloader:didFailToConnect:)]) {
        [self.delegate webViewReloader:self didFailToConnect:nil];
    }
}

#pragma mark - Private Methods

- (NSString *)contentFolderURL {
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    if (infoDictionary[kPListKey] == nil) {
        
    }
    if (infoDictionary[kPListKey][self.webViewIdentifier] == nil) {
        
    }
    return infoDictionary[kPListKey][self.webViewIdentifier];
}

- (WKWebView *)newSocketIOWebView {
    NSString * source = [NSString stringWithFormat:@"connectWithWatcherServer('%@')", self.notifierURL];
    WKUserScript * userScript = [[WKUserScript alloc] initWithSource:source
                                                       injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                    forMainFrameOnly:YES];
    
    WKUserContentController * contentController = [[WKUserContentController alloc] init];
    [contentController addUserScript:userScript];
    [contentController addScriptMessageHandler:self name:kSrcChangeHandlerName];
    [contentController addScriptMessageHandler:self name:kConnectedHandlerName];
    [contentController addScriptMessageHandler:self name:kConnectionErrorHandlerName];
    
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = contentController;
    
    WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) configuration:config];
    webView.navigationDelegate = self;
    return webView;
}

- (void)loadSocketIOWebView {
    NSString * bundlePath = [[NSBundle bundleForClass:[WLXWebViewReloader class]] pathForResource:@"WLXWebViewReloader"
                                                                                           ofType:@"bundle"];
    NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
    NSURL * URL = [bundle URLForResource:@"index" withExtension:@"html"];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    [self.socketIOWebView loadRequest:request];
}

- (void)srcChangeHandler {
    if (!self.webView) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(webViewReloader:willReloadWebView:)]) {
        [self.delegate webViewReloader:self willReloadWebView:self.webView];
    }
        
    [self.webView reload];
        
    if ([self.delegate respondsToSelector:@selector(webViewReloader:willReloadWebView:)]) {
        [self.delegate webViewReloader:self didReloadWebView:self.webView];
    }
}

- (void)connectedHandler {
    self.connected = YES;
    if ([self.delegate respondsToSelector:@selector(webViewReloaderDidConnect:)]) {
        [self.delegate webViewReloaderDidConnect:self];
    }
}

- (void)connectionErrorHandler {
    if ([self.delegate respondsToSelector:@selector(webViewReloader:didFailToConnect:)]) {
        [self.delegate webViewReloader:self didFailToConnect:nil];
    }
    self.connected = NO;
}

@end
