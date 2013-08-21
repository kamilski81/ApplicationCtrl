//
//  OpsCheckSDKTests.m
//  OpsCheckSDKTests
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import "OpsCheckSDKTests.h"
#import "OpsCheck.h"
#import "Constants.h"

#define TEST_APP_KEY @"OpsCheck app key"
#define TEST_APP_VERSION @"appVersion"
#define TEST_APP_BUILD @"appBuild"
#define TEST_EXPECTED_URL @"OpsCheck expected URL"

#define TEST_RESPONSE @"response"


#define TEST_HTTP_VERSION @"HTTP/1.1"


/**
 * Nicer way to access "private" methods and test them
 */
@interface OpsCheck (Test)

- (NSString *)requestURL;

- (void)handleServerResponseWithResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error completionHandler:(OpsCheckCompletionHanlder)handler;

@end


@interface OpsCheckSDKTests ()

@property (atomic, strong) OpsCheck *opsCheck;
@property (nonatomic, strong) NSBundle *testBundle;

@end

@implementation OpsCheckSDKTests

- (void)setUp {
    [super setUp];
    
    
    /**
     * Read testing setting bundle
     */
    self.testBundle = [NSBundle bundleForClass:[self class]];
    
    /**
     * Read test custom settings
     */
    NSString *appVersion = [self.testBundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *appBuild = [self.testBundle objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    NSString *appKey = [self.testBundle objectForInfoDictionaryKey:TEST_APP_KEY];
    
    /**
     * This is an hack to access "private" fields in the ops class so I can test URL creation
     */
    self.opsCheck = [OpsCheck opsCheckWithAppKey:appKey];
    [self.opsCheck setValue:appVersion forKey:TEST_APP_VERSION];
    [self.opsCheck setValue:appBuild forKey:TEST_APP_BUILD];

}

- (void)tearDown {
    // Tear-down code here.
    self.opsCheck = nil;
    self.testBundle = nil;
    [super tearDown];
}

- (void)testUrlCreation {
    NSString *requestURL = [self.opsCheck requestURL];
    NSString *expectedURL = [self.testBundle objectForInfoDictionaryKey:TEST_EXPECTED_URL];
    STAssertEqualObjects(expectedURL, requestURL, @"Request URL - We expected the %@, but it was %@", expectedURL, requestURL);
}


/**
 * This test case is connecting to the server.
 */ 
- (void)testSyncCommucationSuccessStatusCode {
    [self.opsCheck checkSyncVersionWithCompletionHandler:^(BOOL connect, BOOL forceUpdate, NSInteger status, NSString *message, NSError *error) {
        BOOL check = STATUS_SUCCESS == status;
        STAssertTrue(check, @"Status Code - We expected the %d, but it was %d", STATUS_SUCCESS, status);
    }];
}

- (void)testAsyncCommucationSuccessStatusCode {
    [self.opsCheck checkAsyncVersionWithCompletionHandler:^(BOOL connect, BOOL forceUpdate, NSInteger status, NSString *message, NSError *error) {
        BOOL check = STATUS_SUCCESS == status;
        STAssertTrue(check, @"Status Code - We expected the %d, but it was %d", STATUS_SUCCESS, status);
    }];
}


- (void)testConnectReponseHandler {
    

    
    /**
     * Mocking server response
     */
    NSData *data = [NSData data];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:STATUS_CONNECT, OPSCHECK_CHECK_HEADER, @"false", OPSCHECK_FORCE_UPDATE_HEADER, nil];
//    NSDictionary *headerFields = [NSDictionary dictionaryWithObject:STATUS_CONNECT forKey:OPSCHECK_CHECK_HEADER];
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:TEST_EXPECTED_URL] statusCode:STATUS_SUCCESS HTTPVersion:TEST_HTTP_VERSION headerFields:headerFields];
    NSError *error = nil;
    
    
    [self.opsCheck handleServerResponseWithResponse:response data:data error:error completionHandler:^(BOOL connect, BOOL forceUpdate, NSInteger status, NSString *message, NSError *error) {
        /**
         * Check version status == 200
         */
        STAssertTrue(STATUS_SUCCESS == status, @"We expected the handle server version status to be %d, instead is %d", STATUS_SUCCESS, status);
        
        
        /**
         * Check connect status
         */
        STAssertTrue(connect, @"We expected the connect value to be false, instead is %d", connect);
        
        
        /**
         * Check force update status
         */
        STAssertFalse(forceUpdate, @"We expected the force update value to be false, instead is %d", connect);
                
    }];

}

- (void)testDontConnectNoUpdateReponseHandler {
    
    /**
     * Mocking server response
     */
    
    NSData *data = [NSData data];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:STATUS_DONT_CONNECT, OPSCHECK_CHECK_HEADER, @"false", OPSCHECK_FORCE_UPDATE_HEADER, nil];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:TEST_EXPECTED_URL] statusCode:STATUS_SUCCESS HTTPVersion:TEST_HTTP_VERSION headerFields:headerFields];
    NSError *error = nil;
    
    [self.opsCheck handleServerResponseWithResponse:response data:data error:error completionHandler:^(BOOL connect, BOOL forceUpdate, NSInteger status, NSString *message, NSError *error) {
        /**
         * Check version status == 200
         */
        STAssertTrue(STATUS_SUCCESS == status, @"We expected the handle server version status to be %d, instead is %d", STATUS_SUCCESS, status);
        
        
        /**
         * Check connect status
         */
        STAssertFalse(connect, @"We expected the connect value to be false, instead is %d", connect);
        
        /**
         * Check force update status
         */
        STAssertFalse(forceUpdate, @"We expected the force update value to be false, instead is %d", connect);
    }];
}


- (void)testDontConnectForceUpdateReponseHandler {
    
    /**
     * Mocking server response
     */
    
    NSData *data = [NSData data];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:STATUS_DONT_CONNECT, OPSCHECK_CHECK_HEADER, @"true", OPSCHECK_FORCE_UPDATE_HEADER, nil];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:TEST_EXPECTED_URL] statusCode:STATUS_SUCCESS HTTPVersion:TEST_HTTP_VERSION headerFields:headerFields];
    NSError *error = nil;
    
    [self.opsCheck handleServerResponseWithResponse:response data:data error:error completionHandler:^(BOOL connect, BOOL forceUpdate, NSInteger status, NSString *message, NSError *error) {
        /**
         * Check version status == 200
         */
        STAssertTrue(STATUS_SUCCESS == status, @"We expected the handle server version status to be %d, instead is %d", STATUS_SUCCESS, status);
        
        
        /**
         * Check connect status
         */
        STAssertFalse(connect, @"We expected the connect value to be false, instead is %d", connect);
        
        /**
         * Check force update status
         */
        STAssertTrue(forceUpdate, @"We expected the force update value to be true, instead is %d", connect);
    }];
}


- (void)testRequestMalformedReponseHandler {
    
    /**
     * Mocking server response
     */
    NSData *data = [NSData data];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:STATUS_DONT_CONNECT, OPSCHECK_CHECK_HEADER, @"false", OPSCHECK_FORCE_UPDATE_HEADER, nil];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:TEST_EXPECTED_URL] statusCode:STATUS_MALFORMED_REQUEST HTTPVersion:TEST_HTTP_VERSION headerFields:headerFields];
    NSError *error = nil;
    
    
    [self.opsCheck handleServerResponseWithResponse:response data:data error:error completionHandler:^(BOOL connect, BOOL forceUpdate, NSInteger status, NSString *message, NSError *error) {
        /**
         * Check version status == 200
         */
        STAssertTrue(STATUS_MALFORMED_REQUEST == status, @"We expected the handle server version status to be %d, instead is %d", STATUS_MALFORMED_REQUEST, status);
        
        
        /**
         * Check connect status
         */
        STAssertFalse(connect, @"We expected the connect value to be false, instead is %d", connect);
    }];
    
}


- (void)testPermissionDeniedReponseHandler {
    
    /**
     * Mocking server response
     */
    NSData *data = [NSData data];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObjectsAndKeys:STATUS_DONT_CONNECT, OPSCHECK_CHECK_HEADER, @"false", OPSCHECK_FORCE_UPDATE_HEADER, nil];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:TEST_EXPECTED_URL] statusCode:STATUS_PERMISSION_DENIED HTTPVersion:TEST_HTTP_VERSION headerFields:headerFields];
    NSError *error = nil;
    
    [self.opsCheck handleServerResponseWithResponse:response data:data error:error completionHandler:^(BOOL connect, BOOL forceUpdate, NSInteger status, NSString *message, NSError *error) {
        /**
         * Check version status == 200
         */
        STAssertTrue(STATUS_PERMISSION_DENIED == status, @"We expected the handle server version status to be %d, instead is %d", STATUS_PERMISSION_DENIED, status);
        
        
        /**
         * Check connect status
         */
        STAssertFalse(connect, @"We expected the connect value to be false, instead is %d", connect);
    }];
    
}





@end
