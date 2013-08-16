//
//  OCSViewController.m
//  OpsCheckSample
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import "OCSViewController.h"
#import <OpsCheckSDK/OpsCheck.h>

@interface OCSViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *opsCheckWebVuew;

@end

@implementation OCSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    OpsCheck *opsCheck = [OpsCheck opsCheckWithAppKey:@"d44992361e2014c8404f920f36928dada60a27c4"];
    
    //    [opsCheck checkSyncVersionWithCompletionHandler:^(BOOL connect, NSInteger status, NSString *message, NSError *error) {
    //        NSLog(@"Sync");
    //        NSLog(@"OpsCheck info: %@", [opsCheck info]);
    //        NSLog(@"Status: %d - Message: %@", status, message);
    //        NSLog(@"Connect: %d", connect);
    //    }];
    //
    //    [opsCheck checkAsyncVersionWithCompletionHandler:^(BOOL connect, NSInteger status, NSString *message, NSError *error) {
    //        NSLog(@"Sync");
    //        NSLog(@"Error: %@", error);
    //        NSLog(@"OpsCheck info: %@", [opsCheck info]);
    //        NSLog(@"Status: %d - Message: %@", status, message);
    //        NSLog(@"Connect: %d", connect);
    //    }];
    
    //    [opsCheck checkSyncVersionWithCompletionHandler:nil];
    
    [self.opsCheckWebVuew setScalesPageToFit:YES];
    
    [opsCheck checkAsyncVersionWithCompletionHandler:^(BOOL connect, NSInteger status, NSString *message, NSError *error) {
            [self.opsCheckWebVuew loadHTMLString:message baseURL:nil];
     }];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
