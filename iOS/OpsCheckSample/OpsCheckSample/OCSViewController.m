//
//  OCSViewController.m
//  OpsCheckSample
//
//  Created by Giuseppe Macri on 8/14/13.
//  Copyright (c) 2013 Slalom. All rights reserved.
//

#import "OCSViewController.h"
#import <OpsCheckSDK/OpsCheck.h>

@interface OCSViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *opsCheckWebVuew;

@end

@implementation OCSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    OpsCheck *opsCheck = [OpsCheck opsCheckWithAppKey:@"d44992361e2014c8404f920f36928dada60a27c4"];
    
    [self.opsCheckWebVuew setScalesPageToFit:YES];
    [self.opsCheckWebVuew setDelegate:self];
    
    
    [opsCheck checkAsyncVersionWithCompletionHandler:^(BOOL connect, NSInteger status, NSString *message, NSError *error) {
        NSString *webViewcontent = message;
        if (error) {
            webViewcontent = [error localizedDescription];
        }
        [self.opsCheckWebVuew loadHTMLString:message baseURL:[NSURL URLWithString:@"http://localhost:3000/versionings/check"]];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebView delegate

// implement this method in the owning class
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
