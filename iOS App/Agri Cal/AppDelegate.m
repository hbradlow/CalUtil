//
//  AppDelegate.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchImageTransitionController.h"

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
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithWhite:0.2 alpha:1],UITextAttributeTextColor,
                                                          [UIColor clearColor],UITextAttributeTextShadowColor,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset ,
                                                          [UIFont fontWithName:kAppFont size:20.0],UITextAttributeFont, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.90 alpha:1]];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor whiteColor],UITextAttributeTextColor,
                                                             [UIColor blackColor],UITextAttributeTextShadowColor,
                                                             [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                             [UIFont fontWithName:kAppFont size:14.0],UITextAttributeFont, nil]
                                                   forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setContentPositionAdjustment:kSegmentedOffset
                                                   forSegmentType:UISegmentedControlSegmentAny
                                                       barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithWhite:0 alpha:1],UITextAttributeTextColor,
                                                          [UIColor clearColor],UITextAttributeTextShadowColor, nil]
                                                forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor],UITextAttributeTextColor,
                                                       [UIColor blackColor],UITextAttributeTextShadowColor,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                       [UIFont fontWithName:kAppFont size:12.0],UITextAttributeFont, nil]
                                             forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setTintColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"searchbar"]];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"empty"] forState:UIBarMetricsDefault];
    
    NSDictionary *attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor colorWithWhite:0.2 alpha:1], UITextAttributeTextColor,
     [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], UITextAttributeTextShadowColor,
     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
     [UIFont systemFontOfSize:12], UITextAttributeFont,
     nil];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor colorWithWhite:0.95 alpha:1]];
    
    UIImage *segmentUnselectedUnselected = [UIImage imageNamed:@"segdiv"];
    UIImage *segmentSelectedUnselected = [UIImage imageNamed:@"segdiv"];
    UIImage *segUnselectedSelected = [UIImage imageNamed:@"segdiv"];
    
    UIImage *segmentUnselected = [UIImage imageNamed:@"empty"];
    UIImage *segmentSelected = [UIImage imageNamed:@"empty"];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segUnselectedSelected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    
    NSDictionary *segattributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor colorWithWhite:0.1 alpha:1], UITextAttributeTextColor,
     [UIColor colorWithWhite:0.2 alpha:1], UITextAttributeTextShadowColor,
     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
     [UIFont fontWithName:kAppFont size:16], UITextAttributeFont,
     nil];
    [[UISegmentedControl appearance] setTitleTextAttributes:segattributes forState:UIControlStateHighlighted];
    UIOffset offset = UIOffsetMake(0, 1);
    [[UISegmentedControl appearance] setContentPositionAdjustment:offset forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    NSDictionary *segattributesunsel =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor colorWithWhite:0.4 alpha:1], UITextAttributeTextColor,
     [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], UITextAttributeTextShadowColor,
     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
     [UIFont fontWithName:kAppFont size:16], UITextAttributeFont,
     nil];
    [[UISegmentedControl appearance] setTitleTextAttributes:segattributesunsel forState:UIControlStateNormal];
    
    // Autologin to airbears
    self.web = [[UIWebView alloc] init];
    self.web.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://wlan.berkeley.edu/cgi-bin/login/calnet.cgi"];
    NSURLRequest *wifiRequest = [NSURLRequest requestWithURL:url];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
    [self.web loadRequest:wifiRequest];
    });
    
    /* Not currently working, does not seem to stay as top view */
    LaunchImageTransitionController *launchImgController = [[LaunchImageTransitionController alloc] init];
    
    [self.window addSubview:launchImgController.view];
	return YES;
}


-(void)removeSplash:(UIImageView*)splashView{
    [splashView removeFromSuperview];
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
    [self.web loadRequest:wifiRequest];
    });
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
