//
//  ApplicationCtrl.h
//  ApplicationCtrlSDK
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ApplicationCtrlCompletionHanlder)(BOOL connect, BOOL forceUpdate, NSInteger status, NSString *message, NSError *error);


@interface ApplicationCtrl : NSObject

/**
 * Init the ApplicationCtrl singleton class
 */
+ (ApplicationCtrl *)ApplicationCtrlWithAppKey:(NSString *)appKey;


/**
 * Send a sync request to the server
 */
- (void)checkSyncVersionWithCompletionHandler:(ApplicationCtrlCompletionHanlder)handler;

/**
 * Send an async request to the server
 */
- (void)checkAsyncVersionWithCompletionHandler:(ApplicationCtrlCompletionHanlder)handler;

/**
 * Print ApplicationCtrl instance information
 */
- (NSString *)info;


@end
