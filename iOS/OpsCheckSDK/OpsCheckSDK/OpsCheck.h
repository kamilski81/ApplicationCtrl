//
//  OpsCheck.h
//  OpsCheckSDK
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OpsCheckCompletionHanlder)(BOOL connect, NSInteger status, NSString *message, NSError *error);



@interface OpsCheck : NSObject

/**
 * Init the OpsCheck singleton class
 */
+ (OpsCheck *)opsCheckWithAppKey:(NSString *)appKey;


/**
 * Send a sync request to the server
 */
- (void)checkSyncVersionWithCompletionHandler:(OpsCheckCompletionHanlder)handler;

/**
 * Send an async request to the server
 */
- (void)checkAsyncVersionWithCompletionHandler:(OpsCheckCompletionHanlder)handler;

/**
 * Print OpsCHeck instance information
 */
- (NSString *)info;


@end
