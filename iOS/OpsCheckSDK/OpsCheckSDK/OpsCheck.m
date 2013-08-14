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

@interface OpsCheck ()

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

- (void)checkSyncVersion {
        
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *responseData = [self performSyncValidationWithReturningResponse:&response error:&error];
    
    NSString *versionCheck = nil;
    
    if (!error) {
        // Check Response Code
        NSLog(@"DEBUG OPSCHECK - Response: %@", response);
        NSLog(@"DEBUG OPSCHECK - Response code: %d", response.statusCode);
        NSString *body = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        switch (response.statusCode) {
            case 400:
                NSLog(@"DEBUG OPSCHECK - Request is not well formed");
                // read version-check header to get more details
                break;
            case 401:
                NSLog(@"DEBUG OPSCHECK - Permission Denied");
                // read version-check header to get more details
                break;
            case 200:
                versionCheck = [[response allHeaderFields] objectForKey:@"Version-check"];
                // check version-check header
                if (![versionCheck isEqualToString:@"CONNECT"]) {
                    NSLog(@"DEBUG OPSCHECK - Response body: %@", body);
                } else {
                    NSLog(@"DEBUG OPSCHECK - GOOD TO GO! NICE JOB");
                    NSLog(@"DEBUG OPSCHECK - Response body: %@", body);
                }
                break;
            default:
                break;
        }
    } else {
        NSLog(@"DEBUG OPSCHECK - Response error: %@", error);
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
    
    
//    NSString *appVersion =
//    NSString *appBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    
    NSString *customPath = [NSString stringWithFormat:OPSCHECK_PATH,
                            self.appVersion,
                            self.appBuild,
                            self.appKey];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",
                            OPSCHECK_SERVER,
                            [customPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"DEBUG OPSCHECK - URL Request: %@", requestUrl);
    return requestUrl;
}


- (NSData *)performSyncValidationWithReturningResponse:(NSHTTPURLResponse **)response error:(NSError **)error {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self requestURL]]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:10];

    return [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error] ;
}

#pragma mark - pint info

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
