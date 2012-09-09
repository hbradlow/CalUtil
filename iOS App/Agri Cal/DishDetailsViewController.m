//
//  DishDetailsViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import "DishDetailsViewController.h"

@interface DishDetailsViewController ()

@end

@implementation DishDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.web.backgroundColor = [UIColor clearColor];
    NSURL *url = [NSURL URLWithString:self.url];
    [self.web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.web];
}

@end
