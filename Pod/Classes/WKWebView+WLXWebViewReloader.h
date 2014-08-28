//
//  WKWebView+WLXWebViewReloader.h
//  Pods
//
//  Created by Guido Marucci Blas on 8/26/14.
//
//

#import <Foundation/Foundation.h>
#import "WLXWebViewReloader.h"


@import WebKit;

@interface WKWebView (WLXWebViewReloader)

@property (nonatomic) NSString * reloaderIdentifier;
@property (nonatomic) WLXWebViewReloader * reloader;
@property (nonatomic, weak) id<WLXWebViewReloaderDelegate> reloaderDelegate;

- (void)reloadOnFileChange;

- (WKNavigation *)loadLocalRequest:(NSURLRequest *)request;

- (void)startListeningToFileChanges;

- (void)stopListeningToFileChanges;

@end
