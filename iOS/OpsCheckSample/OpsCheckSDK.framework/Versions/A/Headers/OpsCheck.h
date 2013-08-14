//
//  OpsCheck.h
//  OpsCheckSDK
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpsCheck : NSObject

+ (OpsCheck *)opsCheckWithAppKey:(NSString *)appKey;
- (void)checkVersion;

@end
