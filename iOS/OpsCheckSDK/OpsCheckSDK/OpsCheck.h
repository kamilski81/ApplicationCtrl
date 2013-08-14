//
//  OpsCheck.h
//  OpsCheckSDK
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpsCheck : NSObject

/**
 * Init the OpsCheck singleton class
 */
+ (OpsCheck *)opsCheckWithAppKey:(NSString *)appKey;


/**
 * Send a sync request to the server
 */
- (BOOL)checkSyncVersion;


/**
 * Print OpsCHeck instance information
 */
- (NSString *)info;


@end
