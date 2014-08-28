//
//  WKWebView+WLXWebViewReloader.m
//  Pods
//
//  Created by Guido Marucci Blas on 8/26/14.
//
//

#import "WKWebView+WLXWebViewReloader.h"

#import <objc/runtime.h>

static char kWebViewReloaderKey;
static char kWebViewReloaderDelegateKey;

@implementation WKWebView (WLXWebViewReloader)

@dynamic reloaderIdentifier;
@dynamic reloaderDelegate;

- (void)reloadOnFileChange {
    WLXWebViewReloader * reloader = [WLXWebViewReloader reloaderWithWebViewIdentifier:self.reloaderIdentifier];
    self.reloader = reloader;
    reloader.delegate = self.reloaderDelegate;
    reloader.webView = self;
}

- (WKNavigation *)loadLocalRequest:(NSURLRequest *)request {
    if (self.reloader) {
        request = [NSURLRequest requestWithURL:self.reloader.contentURL];
    }
    return [self loadRequest:request];
}

- (void)startListeningToFileChanges {
    [self.reloader connect];
}

- (void)stopListeningToFileChanges {
    [self.reloader disconnect];
}

- (void)setReloaderIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(reloaderIdentifier), identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)reloaderIdentifier {
    return objc_getAssociatedObject(self, @selector(reloaderIdentifier));
}

- (WLXWebViewReloader *)reloader {
    return objc_getAssociatedObject(self, &kWebViewReloaderKey);
}

- (void)setReloader:(WLXWebViewReloader *)webViewReloader {
    objc_setAssociatedObject(self, &kWebViewReloaderKey, webViewReloader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<WLXWebViewReloaderDelegate>)reloaderDelegate {
    return objc_getAssociatedObject(self, &kWebViewReloaderDelegateKey);
}

- (void)setReloaderDelegate:(id<WLXWebViewReloaderDelegate>)reloaderDelegate {
    objc_setAssociatedObject(self, &kWebViewReloaderDelegateKey, reloaderDelegate, OBJC_ASSOCIATION_ASSIGN);
    self.reloader.delegate = reloaderDelegate;
}

@end
