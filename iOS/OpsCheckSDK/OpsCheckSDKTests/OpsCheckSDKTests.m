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



/**
 * Nicer way to access "private" methods and test them
 */
@interface OpsCheck (Test)

- (NSString *)requestURL;

@end


@interface OpsCheckSDKTests ()

@property (atomic, strong) OpsCheck *opsCheck;
@property (nonatomic, strong) NSBundle *testBundle;

@end

@implementation OpsCheckSDKTests

- (void)setUp
{
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

- (void)tearDown
{
    // Tear-down code here.
    self.opsCheck = nil;
    self.testBundle = nil;
    [super tearDown];
}

- (void)testUrlCreation
{
    NSString *requestURL = [self.opsCheck requestURL];
    NSString *expectedURL = [self.testBundle objectForInfoDictionaryKey:TEST_EXPECTED_URL];
    STAssertEqualObjects(expectedURL, requestURL, @"We expected the %@, but it was %@", expectedURL, requestURL);
}

@end
