# WLXWebViewReloader

[![Version](https://img.shields.io/cocoapods/v/WLXWebViewReloader.svg?style=flat)](http://cocoadocs.org/docsets/WLXWebViewReloader)
[![License](https://img.shields.io/cocoapods/l/WLXWebViewReloader.svg?style=flat)](http://cocoadocs.org/docsets/WLXWebViewReloader)
[![Platform](https://img.shields.io/cocoapods/p/WLXWebViewReloader.svg?style=flat)](http://cocoadocs.org/docsets/WLXWebViewReloader)

**WLXWebViewReloader** helps you develop iOS projects that depend on
code executed inside a `WKWebView`. As you might know every time you
update a resource file (like a Javascript source file) you need
to perform a clean build in order for those changes to get updated
into the `ipa` file.  Depending on the size of your project and the
amount of resources could take quite a bit of time and doing a clean install every time you update a line of (Javascript) code might
upset you.

Using this Pod and the [webview-reloader-server](http://github.com/Wolox/webview-reloader-server) you no longer need to do a clean install every time you update your
Javascript code. The webview-reloader-server will watch for changes in your source code and it will automatically reload the webview. The server also serves (pound intended) the webview's HTML page for you to be able to edit the source code without needing to re-deploy the app.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

For this Pod to actually work you need to install the [webview-reloader-server](http://github.com/Wolox/webview-reloader-server).

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
    [self.webView reloadOnFileChange];
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

## About ##

This project is maintained by [Guido Marucci Blas](https://github.com/guidomb) and it was written by [Wolox](http://www.wolox.com.ar).

![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)

## License

**WLXWebViewReloader** is available under the MIT [license](https://raw.githubusercontent.com/Wolox/WLXWebViewReloader/master/LICENSE).

    Copyright (c) 2014 Guido Marucci Blas <guidomb@wolox.com.ar>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
