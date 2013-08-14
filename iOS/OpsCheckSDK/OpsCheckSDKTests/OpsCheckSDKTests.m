//
//  OpsCheckSDKTests.m
//  OpsCheckSDKTests
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import "OpsCheckSDKTests.h"
#import "OpsCheck.h"

#define TEST_APP_KEY @"OpsCheck app key"
#define TEST_APP_VERSION @"appVersion"
#define TEST_APP_BUILD @"appBuild"
#define TEST_EXPECTED_URL @"OpsCheck expected URL"

#define TEST_RESPONSE @"response"
#define TEST_STATUS_SUCCESS 200
#define TEST_STATUS_REQUEST_MALFORMED 400
#define TEST_STATUS_PERMISSION_DENIED 401

#define TEST_HTTP_VERSION @"HTTP/1.1"

#define TEST_OPSCHECK_HEADER @"Version-Check"
#define TEST_STATUS_CONNECT @"CONNECT"
#define TEST_STATUS_DONT_CONNECT @"DON'T CONNECT"


/**
 * Nicer way to access "private" methods and test them
 */
@interface OpsCheck (Test) <NSURLConnectionDataDelegate>

- (NSString *)requestURL;
- (NSHTTPURLResponse *)response;
- (NSData *)data;
- (NSError *)error;
- (NSInteger)versionStatus;

- (void)clear;

- (BOOL)handleServerResponse;

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
    [self.opsCheck clear];
}


/**
 * This test case is connecting to the server.
 */ 
- (void)testSyncCommucationSuccessStatusCode {
    [self.opsCheck checkSyncVersion];
    NSHTTPURLResponse *response = [self.opsCheck response];
    NSInteger statusCode = [response statusCode];
    BOOL check = TEST_STATUS_SUCCESS == statusCode;
    STAssertTrue(check, @"Status Code - We expected the %d, but it was %d", TEST_STATUS_SUCCESS, statusCode);
    [self.opsCheck clear];
}


- (void)testConnectReponseHandler {
    
    /**
     * Checking if fields are empty
     */
    NSData *data = [self.opsCheck data];
    NSHTTPURLResponse *response = [self.opsCheck response];
    NSError *error = [self.opsCheck error];
    
    STAssertNil(data, @"Data - We expected the OpsCheck data field to be nil, instead is %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    STAssertNil(response, @"Data - We expected the OpsCheck data field to be nil, instead is %@", response);
    STAssertNil(error, @"Error - We expected the OpsCheck data field to be nil, instead is %@", error);
    
    /**
     * Mocking server response
     */
    data = [NSData data];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObject:TEST_STATUS_CONNECT forKey:TEST_OPSCHECK_HEADER];
    response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:TEST_EXPECTED_URL] statusCode:TEST_STATUS_SUCCESS HTTPVersion:TEST_HTTP_VERSION headerFields:headerFields];
    error = nil;
    [self.opsCheck connection:nil didReceiveResponse:response];
    [self.opsCheck connection:nil didReceiveData:[NSData data]];
    [self.opsCheck connectionDidFinishLoading:nil];
    
    BOOL result = [self.opsCheck handleServerResponse];
    
    /**
     * Check version status == 200
     */
    NSInteger versionStatus = [self.opsCheck versionStatus];
    STAssertTrue(TEST_STATUS_SUCCESS == [self.opsCheck versionStatus], @"We expected the handle server version status to be %d, instead is %d", TEST_STATUS_SUCCESS, versionStatus);
    
    
    /**
     * Check result status
     */
    STAssertTrue(result, @"We expected the handle server response to be false, instead is %d", result);
    [self.opsCheck clear];
    
}

- (void)testDontConnectReponseHandler {
    
    /**
     * Checking if fields are empty
     */
    NSData *data = [self.opsCheck data];
    NSHTTPURLResponse *response = [self.opsCheck response];
    NSError *error = [self.opsCheck error];
    
    STAssertNil(data, @"Data - We expected the OpsCheck data field to be nil, instead is %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    STAssertNil(response, @"Data - We expected the OpsCheck data field to be nil, instead is %@", response);
    STAssertNil(error, @"Error - We expected the OpsCheck data field to be nil, instead is %@", error);
    
    /**
     * Mocking server response
     */
    data = [NSData data];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObject:TEST_STATUS_DONT_CONNECT forKey:TEST_OPSCHECK_HEADER];
    response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:TEST_EXPECTED_URL] statusCode:TEST_STATUS_SUCCESS HTTPVersion:TEST_HTTP_VERSION headerFields:headerFields];
    error = nil;
    [self.opsCheck connection:nil didReceiveResponse:response];
    [self.opsCheck connection:nil didReceiveData:[NSData data]];
    [self.opsCheck connectionDidFinishLoading:nil];
    
    BOOL result = [self.opsCheck handleServerResponse];
    
    /**
     * Check version status == 200
     */
    NSInteger versionStatus = [self.opsCheck versionStatus];
    STAssertTrue(TEST_STATUS_SUCCESS == [self.opsCheck versionStatus], @"We expected the handle server version status to be %d, instead is %d", TEST_STATUS_SUCCESS, versionStatus);
    
    /**
     * Check result status == false
     */
    STAssertFalse(result, @"We expected the handle server response to be false, instead is %d", result);
    [self.opsCheck clear];
    
}

- (void)testRequestMalformedReponseHandler {
    
    /**
     * Checking if fields are empty
     */
    NSData *data = [self.opsCheck data];
    NSHTTPURLResponse *response = [self.opsCheck response];
    NSError *error = [self.opsCheck error];
    
    STAssertNil(data, @"Data - We expected the OpsCheck data field to be nil, instead is %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    STAssertNil(response, @"Data - We expected the OpsCheck data field to be nil, instead is %@", response);
    STAssertNil(error, @"Error - We expected the OpsCheck data field to be nil, instead is %@", error);
    
    /**
     * Mocking server response
     */
    data = [NSData data];
    NSDictionary *headerFields = [NSDictionary dictionaryWithObject:TEST_STATUS_DONT_CONNECT forKey:TEST_OPSCHECK_HEADER];
    response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:TEST_EXPECTED_URL] statusCode:TEST_STATUS_REQUEST_MALFORMED HTTPVersion:TEST_HTTP_VERSION headerFields:headerFields];
    error = nil;
    [self.opsCheck connection:nil didReceiveResponse:response];
    [self.opsCheck connection:nil didReceiveData:[NSData data]];
    [self.opsCheck connectionDidFinishLoading:nil];
    
    BOOL result = [self.opsCheck handleServerResponse];
    
    /**
     * Check version status == 200
     */
    NSInteger versionStatus = [self.opsCheck versionStatus];
    STAssertTrue(TEST_STATUS_REQUEST_MALFORMED == [self.opsCheck versionStatus], @"We expected the handle server version status to be %d, instead is %d", TEST_STATUS_REQUEST_MALFORMED, versionStatus);
    
    /**
     * Check result status == false
     */
    STAssertFalse(result, @"We expected the handle server response to be false, instead is %d", result);
    [self.opsCheck clear];
    
}






@end
