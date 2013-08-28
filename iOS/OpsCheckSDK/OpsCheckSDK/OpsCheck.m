//
//  OpsCheck.m
//  OpsCheckSDK
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import "OpsCheck.h"
#import "Constants.h"
#import <UIKit/UIKit.h>



@interface OpsCheck () <NSURLConnectionDataDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSString *opsCheckServer;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appBuild;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation OpsCheck

+ (OpsCheck *)opsCheckWithAppKey:(NSString *)appKey {
    static dispatch_once_t _singletonPredicate;
    static OpsCheck *_singleton = nil;
    
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[self alloc] initWithappKey:appKey];
    });
    
    return _singleton;
    
}

- (id)initWithappKey:(NSString *)appKey {
    self = [super init];
    if (self) {
        self.opsCheckServer = [[NSBundle mainBundle] objectForInfoDictionaryKey:OPSCHECK_SERVER];
        self.appKey = appKey;
    }
    
    return self;
}

- (void)dealloc {
    self.appKey = nil;
    self.appVersion = nil;
    self.appBuild = nil;
    
    self.webView = nil;
}


#pragma mark - Synchronous version check

- (void)checkSyncVersionWithCompletionHandler:(OpsCheckCompletionHanlder)handler {
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [self performSyncValidationWithRequest:[self request] response:&response error:&error];
    
    [self handleServerResponseWithResponse:response data:data error:error completionHandler:handler];
    
}


- (void)checkAsyncVersionWithCompletionHandler:(OpsCheckCompletionHanlder)handler {
    [NSURLConnection sendAsynchronousRequest:[self request] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [self handleServerResponseWithResponse:(NSHTTPURLResponse *)response data:data error:error completionHandler:handler];
    }];
}

/**
 * Response Handler
 */

- (void)handleServerResponseWithResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error completionHandler:(OpsCheckCompletionHanlder)handler {
    NSString *versionCheck = nil;
    BOOL forceUpdateCheck = NO;
    BOOL connect = NO;
    NSString *body = nil;
    if (!error) {
        // Check Response Code
        body = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        switch (response.statusCode) {
            case STATUS_MALFORMED_REQUEST:
                connect = NO;
                forceUpdateCheck = NO;
                break;
            case STATUS_PERMISSION_DENIED:
                connect = NO;
                forceUpdateCheck = NO;
                break;
            case STATUS_SUCCESS: {
                versionCheck = [[response allHeaderFields] objectForKey:OPSCHECK_CHECK_HEADER];
                
                // check version-check header
                if (![versionCheck isEqualToString:STATUS_CONNECT]) {
                    connect = NO;
                    // check force update header
                    NSString *forceUpdateCheckString = [[response allHeaderFields] objectForKey:OPSCHECK_FORCE_UPDATE_HEADER];
                    forceUpdateCheck = [forceUpdateCheckString boolValue];
                } else {
                    connect = YES;
                    forceUpdateCheck = NO;
                }
            }
                break;
            default:
                break;
        }
    } else {
        NSLog(@"DEBUG OPSCHECK - Response error: %@", error);
    }
    
    
    if (handler) {
        handler(connect, forceUpdateCheck, response.statusCode, body, error);
    } else {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:connect], @"connect",
                                [NSNumber numberWithBool:forceUpdateCheck], @"forceUpdate",
                                [NSNumber numberWithInt:response.statusCode], @"statusCode",
                                body, @"body",
                                error, @"error",
                                nil];
        [self showWebView:params];
    }
    
}



#pragma mark - communication methods


- (NSString *)requestURL {
    
    if (!self.appVersion) {
        self.appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    }
    
    if (!self.appBuild) {
        self.appBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    }
    
    
    
    
    NSString *customPath = [NSString stringWithFormat:OPSCHECK_PATH,
                            self.appVersion,
                            self.appBuild,
                            self.appKey];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",
                            self.opsCheckServer,
                            [customPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    return requestUrl;
}


- (NSURLRequest *)request {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self requestURL]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    
    return request;
    
}


- (NSData *)performSyncValidationWithRequest:(NSURLRequest *)request response:(NSHTTPURLResponse **)response error:(NSError **)error {
    return [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error] ;
}


- (NSURLConnection *)urlConnectionForURLRequest:(NSURLRequest *)request {
    return [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


#pragma mark - print info

- (NSString *)info {
    return [NSString stringWithFormat:@"Key: %@ - Version: %@ - Build: %@", self.appKey, self.appVersion, self.appBuild];
}


#pragma mark - Show feedback to user
// TODO: use a webview by defautl

- (void)showWebView:(NSDictionary *)params {
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = appDelegate.window;
    
    /**
     * Hiding status bar
     */
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    /**
     * Creating webview to display message
     */
    self.webView = [[UIWebView alloc] initWithFrame:window.frame];
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
    [self.webView loadHTMLString:[params objectForKey:@"body"] baseURL:[NSURL URLWithString:@"http://localhost:3000/versionings/check"]];
    [window addSubview:self.webView];

   
    
}

#pragma mark - UIWebView delegate

// implement this method in the owning class
- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        
        NSString *url = inRequest.URL.absoluteString;
        if ([url rangeOfString:@"itunes.apple.com"].location == NSNotFound) {
            if ([url isEqualToString:@"app://close-view"]) {
                [self closeWebView];
                return NO;
            }
        } else {
            [[UIApplication sharedApplication] openURL:[inRequest URL]];
        }
        return NO;
    }
    
    return YES;
}


// Close web view UI
- (void)closeWebView {
    [self.webView setHidden:YES];
    self.webView = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}




@end
