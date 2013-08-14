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

#define DEBUG_PREFIX @"DEBUG OPSCHECK -"

@interface OpsCheck () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appBuild;

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSError *error;

@property NSInteger versionStatus;

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

- (BOOL)checkSyncVersion {
        
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self requestURL]]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:10];
    
    self.data = [self performSyncValidationWithRequest:request response:&response error:&error];
    self.response = response;
    self.error = error;
    
    
    
    return [self handleServerResponse];
}


- (void)checkAsyncVersion {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self requestURL]]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:10];
    NSURLConnection *connection = [self urlConnectionForURLRequest:request];
    [connection start];
    
}

/**
 * Response Handler
 */

- (BOOL)handleServerResponse {
    NSString *versionCheck = nil;
    
    if (!self.error) {
        // Check Response Code
//        NSString *body = [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
        switch (self.response.statusCode) {
            case 400:
//                NSLog(@"DEBUG OPSCHECK - Request is not well formed");
                // read version-check header to get more details
                self.versionStatus = 400;
                break;
            case 401:
//                NSLog(@"DEBUG OPSCHECK - Permission Denied");
                // read version-check header to get more details
                self.versionStatus = 401;
                break;
            case 200:
                versionCheck = [[self.response allHeaderFields] objectForKey:OPSCHECK_HEADER];
                self.versionStatus = 200;
                // check version-check header
                if (![versionCheck isEqualToString:STATUS_CONNECT]) {
//                    NSLog(@"DEBUG OPSCHECK - Response body: %@", body);
                } else {
//                    NSLog(@"DEBUG OPSCHECK - GOOD TO GO! NICE JOB");
//                    NSLog(@"DEBUG OPSCHECK - Response body: %@", body);
                    return YES;
                }
                break;
            default:
                break;
        }
    } else {
        NSLog(@"DEBUG OPSCHECK - Response error: %@", self.error);
    }
    
    return NO;
}



- (void)clear {
    self.response = nil;
    self.data = nil;
    self.error = nil;
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
    
//    NSLog(@"DEBUG OPSCHECK - URL Request: %@", requestUrl);
    return requestUrl;
}


- (NSData *)performSyncValidationWithRequest:(NSURLRequest *)request response:(NSHTTPURLResponse **)response error:(NSError **)error {
    return [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error] ;
}


- (NSURLConnection *)urlConnectionForURLRequest:(NSURLRequest *)request {
    return [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


#pragma mark - NSURLConnection delegates (Async Call only)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"%@ Data received: %@", DEBUG_PREFIX, data);
    self.data = data;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSLog(@"%@ Reponse received: %@", DEBUG_PREFIX, response);
    self.response = (NSHTTPURLResponse *)response;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    NSLog(@"%@ Connection failed! Error - %@ %@",
//          DEBUG_PREFIX,
//          [error localizedDescription],
//          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    self.error = error;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    [self handleServerResponse];
}

#pragma mark - print info

- (NSString *)info {
    return [NSString stringWithFormat:@"Key: %@ - Version: %@ - Build: %@", self.appKey, self.appVersion, self.appBuild];
}



//- (void)showMessage:(NSString *)body {
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello World!"
//                                                      message:body
//                                                     delegate:nil
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//    [message show];
//}



@end
