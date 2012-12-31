//
//  NewsStoryViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/13/12.
//
//

#import "NewsStoryViewController.h"

@interface NewsStoryViewController ()

@end

@implementation NewsStoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView loadHTMLString:self.story.content baseURL:nil];
    self.navigationItem.title = self.story.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
