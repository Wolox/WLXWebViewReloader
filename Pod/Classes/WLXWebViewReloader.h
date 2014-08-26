//
//  WebViewReloader.h
//  WebViewReloader
//
//  Created by Guido Marucci Blas on 8/25/14.
//  Copyright (c) 2014 Wolox. All rights reserved.
//

#import <Foundation/Foundation.h>

@import WebKit;

@class WLXWebViewReloader;

@protocol WLXWebViewReloaderDelegate <NSObject>

- (void)webViewReloader:(WLXWebViewReloader *)reloader didFailToConnect:(NSError *)error;

- (void)webViewReloaderDidConnect:(WLXWebViewReloader *)reloader;

- (void)webViewReloader:(WLXWebViewReloader *)reloader willReloadWebView:(WKWebView *)webView;

- (void)webViewReloader:(WLXWebViewReloader *)reloader didReloadWebView:(WKWebView *)webView;

@end

@interface WLXWebViewReloader : NSObject

@property (nonatomic, readonly) NSString * webViewIdentifier;
@property (nonatomic, weak) WKWebView * webView;
@property (nonatomic, readonly) NSURL * serverURL;
@property (nonatomic, weak) id<WLXWebViewReloaderDelegate> delegate;
@property (nonatomic, readonly) NSURL * notifierURL;
@property (nonatomic, readonly) NSURL * contentURL;

+ (NSURL *)defaultServerURL;

+ (void)setDefaultServerURL:(NSURL *)serverURL;

+ (instancetype)reloaderWithWebViewIdentifier:(NSString *)webViewIdentifier;

- (instancetype)initWithServerURL:(NSURL *)URL webViewIdentifier:(NSString *)webViewIdentifier andWebView:(WKWebView *)webView;

- (void)connect;

- (void)disconnect;
    

@end
