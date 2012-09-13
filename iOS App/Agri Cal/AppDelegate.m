//
//  AppDelegate.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize username = _username;
@synthesize password = _password;
@synthesize web = _web;

/*  
    When the application finnishes launching, a POST-request is sent to the 
    server to get Cal1Card balance, Mealpoints, and automatically log the user 
    in to Air Bears. 
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    // Autologin to airbears
    self.web = [[UIWebView alloc] init];
    self.web.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://wlan.berkeley.edu/cgi-bin/login/calnet.cgi"];
    NSURLRequest *wifiRequest = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:wifiRequest];
    
    return YES;
}

/*  
    The same thing happens each time the application enters the foreground
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Autologin to airbears
    self.web = [[UIWebView alloc] init];
    self.web.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://wlan.berkeley.edu/cgi-bin/login/calnet.cgi"];
    NSURLRequest *wifiRequest = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:wifiRequest];
    [self loadBalances];
}

- (void)loadBalances
{
    NSString *queryString = [NSString stringWithFormat:@"%@/balance/?username=%@&password=%@", ServerURL, [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSError *error = nil;
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    NSURLResponse *response = nil;
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                 returningResponse:&response
                                                             error:&error];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];
    
    if (dict)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"meal_points"] forKey:kMealpoints];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"balance"] forKey:kCalBalance];
    }
}

/*
    This method handles the automated Air Bears login.
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.web stringByEvaluatingJavaScriptFromString:@"document.getElementById('loginsubmit').submit()"];
    [self.web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('username').value='%@';", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]];
    [self.web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('password').value='%@';", [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]]];
    [self.web stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit();"];
}

@end
