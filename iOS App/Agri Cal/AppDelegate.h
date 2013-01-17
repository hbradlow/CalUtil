//
//  AppDelegate.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "NewsListViewController.h"
#import "SettingsViewController.h"
#import "MapViewController.h"
#import "RevealController.h"
#import "ZUUIRevealController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIWebViewDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) UIWebView *web;
@property (strong, nonatomic) RevealController *viewController;

@property BOOL hasLoaded;
@end
