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

static NSString * const kLoggerHandlerName = @"loggerHandler";

static NSString * const kPListKey = @"WLXWebViewReloader";

static NSURL * serverURL;

@interface WLXWebViewReloader ()<WKScriptMessageHandler, WKNavigationDelegate>

@property (nonatomic) WKWebView * socketIOWebView;
@property (nonatomic, getter=isConnected) BOOL connected;
@property (nonatomic, readonly) NSURL * socketIOWebViewURL;

@end

@implementation WLXWebViewReloader

@dynamic contentURL;
@dynamic notifierURL;

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
        _connected = NO;
    }
    return self;
}

- (NSURL *)socketIOWebViewURL {
    NSString * query = [NSString stringWithFormat:@"?host=webview&identifier=%@", self.webViewIdentifier];
#ifdef DEBUG
    query = [query stringByAppendingString:@"&debugMode=true"];
#endif
    NSString * stringURL = [self.serverURL.absoluteString stringByAppendingString:query];
    return [NSURL URLWithString:stringURL];
}

- (NSURL *)notifierURL {
    return [self.serverURL URLByAppendingPathComponent:_webViewIdentifier];
}

- (NSURL *)contentURL {
    return [self.notifierURL URLByAppendingPathComponent:@""];
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
    if ([message.name isEqualToString:kLoggerHandlerName]) {
        [self loggerHandler:message.body];
    }
}

#pragma mark - WKNavigationDelegate delegate methods

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webViewReloader:didFailToConnect:)]) {
        [self.delegate webViewReloader:self didFailToConnect:nil];
    }
    [self loggerHandler:[NSString stringWithFormat:@"error: %@", error]];
}

- (void)webView:(WKWebView *)webView
didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webViewReloader:didFailToConnect:)]) {
        [self.delegate webViewReloader:self didFailToConnect:nil];
    }
    [self loggerHandler:[NSString stringWithFormat:@"error: %@", error]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self loggerHandler:@"finish navigation"];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self loggerHandler:@"start provisional navigation"];
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
    WKUserContentController * contentController = [[WKUserContentController alloc] init];
    [contentController addScriptMessageHandler:self name:kSrcChangeHandlerName];
    [contentController addScriptMessageHandler:self name:kConnectedHandlerName];
    [contentController addScriptMessageHandler:self name:kConnectionErrorHandlerName];
#ifdef DEBUG
    [contentController addScriptMessageHandler:self name:kLoggerHandlerName];
#endif
    
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = contentController;
    
    WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) configuration:config];
    webView.navigationDelegate = self;
    return webView;
}

- (void)attachSocketIOWebView {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat x = - (2 * screenRect.size.width + self.socketIOWebView.frame.size.width);
    self.socketIOWebView.frame = CGRectMake(x, 0, self.socketIOWebView.bounds.size.width, self.socketIOWebView.bounds.size.height);
    [self.webView.superview addSubview:self.socketIOWebView];
}

- (void)loadSocketIOWebView {
    [self attachSocketIOWebView];
    NSURLRequest * request = [NSURLRequest requestWithURL:self.socketIOWebViewURL];
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

- (void)loggerHandler:(NSString *)message {
#ifdef DEBUG
    NSLog(@"SocketIOWebView: %@", message);
#endif
}

@end
