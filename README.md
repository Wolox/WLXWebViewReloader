# WLXWebViewReloader

[![CI Status](http://img.shields.io/travis/Guido Marucci Blas/WLXWebViewReloader.svg?style=flat)](https://travis-ci.org/Guido Marucci Blas/WLXWebViewReloader)
[![Version](https://img.shields.io/cocoapods/v/WLXWebViewReloader.svg?style=flat)](http://cocoadocs.org/docsets/WLXWebViewReloader)
[![License](https://img.shields.io/cocoapods/l/WLXWebViewReloader.svg?style=flat)](http://cocoadocs.org/docsets/WLXWebViewReloader)
[![Platform](https://img.shields.io/cocoapods/p/WLXWebViewReloader.svg?style=flat)](http://cocoadocs.org/docsets/WLXWebViewReloader)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

For this Pod actually work you need to install the [webview-reloader-server](http://github.com/Wolox/webview-reloader-server).

    brew install node
    npm install -g webview-reloader-server

## Installation

WLXWebViewReloader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "WLXWebViewReloader"

## Usage

In your view controller import `WLWebViewReloader` category

```objc
#import <WLXWebViewReloader/WKWebView+WLXWebViewReloader.h>
```

and here is an example of how to configure the web view

```objc
#import "ViewController.h"
#import <WLXWebViewReloader/WKWebView+WLXWebViewReloader.h>

@import WebKit;

@interface ViewController ()<WKNavigationDelegate, WLXWebViewReloaderDelegate>

@property (nonatomic) WKWebView * webView;
@property (nonatomic) WLXWebViewReloader * webViewReloader;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    self.webView = [[WKWebView alloc] init];
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    self.webView.reloaderIdentifier = @"MyWebView";
    self.webView.reloaderDelegate = self;
    [self.webView reloadOnFileChangeThatMatches:@".*\\.html"];
#endif
    
    NSURL * URL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
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
```

The `reloaderIdentifier` of the web view needs to match the listener's name you configured in the
webview-reloader-server's configuration file.

Also you need to call `loadLocalRequest:` instead of `loadRequest` to be able to load the source
code from the web server. If the reloader has not been configured the `loadLocalRequest` forwards
to `loadRequest`.

## Author

Guido Marucci Blas, guidomb@gmail.com

## License

WLXWebViewReloader is available under the MIT license. See the LICENSE file for more info.

