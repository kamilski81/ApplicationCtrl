//
//  OpsCheck.m
//  OpsCheckSDK
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import "OpsCheck.h"
#import <UIKit/UIKit.h>


#define OPSCHECK_SERVER @"http://localhost:3000"
#define OPSCHECK_PATH @"/versionings/check?version=%@&build=%@&app_key=%@"

#define OPSCHECK_HEADER @"Version-Check"
#define STATUS_CONNECT @"CONNECT"
#define STATUS_DONT_CONNECT @"DON'T CONNECT"

#define STATUS_SUCCESS 200
#define STATUS_MALFORMED_REQUEST 400
#define STATUS_PERMISSION_DENIED 401



#define DEBUG_PREFIX @"DEBUG OPSCHECK -"


@interface OpsCheck () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appBuild;

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
        self.appKey = appKey;
    }
    
    return self;
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
    BOOL connect = NO;
    NSString *body = nil;
    if (!error) {
        // Check Response Code
        body = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        switch (response.statusCode) {
            case STATUS_MALFORMED_REQUEST:
                break;
            case STATUS_PERMISSION_DENIED:
                break;
            case STATUS_SUCCESS:
                versionCheck = [[response allHeaderFields] objectForKey:OPSCHECK_HEADER];
                
                // check version-check header
                if (![versionCheck isEqualToString:STATUS_CONNECT]) {
                    
                } else {
                    connect = YES;
                }
                break;
            default:
                break;
        }
    } else {
        NSLog(@"DEBUG OPSCHECK - Response error: %@", error);
    }
    
    
    NSString *message = body;
    
    if (handler) {
        handler(connect, response.statusCode, body, error);
    } else if (!connect) {
        
        message = [error localizedDescription];
        
        [self showMessage:message];
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
                            OPSCHECK_SERVER,
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



- (void)showMessage:(NSString *)body {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Not Able to connect"
                                                      message:body
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}



@end
