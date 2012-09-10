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
    self.web = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.web.backgroundColor = [UIColor clearColor];
    self.url = [NSString stringWithFormat:@"%@/nutrition/%@/", ServerURL, self.url];
    NSURL *url = [NSURL URLWithString:self.url];
    [self.web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.web];
}

@end
