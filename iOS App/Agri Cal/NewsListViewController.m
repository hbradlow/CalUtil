//
//  NewsListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/10/12.
//
//

#import "NewsListViewController.h"
#import "NewsStory.h"
#import "AppDelegate.h"

@interface NewsListViewController ()

@end

@implementation NewsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rssFeed = [[NSMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [self loadRSS];
    });
    
    UIImage* image=[UIImage imageNamed:@"SplashScreenAnimated.png"];
    if (!((AppDelegate*)[[UIApplication sharedApplication] delegate]).hasLoaded)
    {
        self.splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,-20,320,480)];
        self.splashView.image = image;
        [self.view addSubview:self.splashView];
        [self.view bringSubviewToFront:self.splashView];
        [self performSelector:@selector(removeSplash) withObject:self afterDelay:0];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).hasLoaded = YES;
    }
}

-(void)removeSplash{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [self.splashView setAlpha:0];
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],UITextAttributeTextColor,[UIColor blackColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset ,[UIFont fontWithName:@"UCBerkeleyOS" size:28.0],UITextAttributeFont, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0 green:63.0/255 blue:135.0/255 alpha:1]];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],UITextAttributeTextColor,[UIColor blackColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset ,[UIFont fontWithName:@"UCBerkeleyOS-Demi" size:20.0],UITextAttributeFont, nil] forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setContentPositionAdjustment:UIOffsetMake(0, 2) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],UITextAttributeTextColor,[UIColor blackColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset , [UIFont fontWithName:@"UCBerkeleyOS" size:20.0],UITextAttributeFont, nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 2) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],UITextAttributeTextColor,[UIColor blackColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset ,[UIFont fontWithName:@"UCBerkeleyOS" size:12.0],UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:0 green:63.0/255 blue:135.0/255 alpha:1]];
}

- (void)loadRSS
{
    /*
     NSString *queryString = [NSString stringWithFormat:@"%@/dailycal/", ServerURL];
     NSURL *requestURL = [NSURL URLWithString:queryString];
     NSURLResponse *response = nil;
     NSError *error = nil;
     
     NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
     
     NSData *receivedData;
     receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
     returningResponse:&response
     error:&error];
     
     NSArray *receivedArray = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];
     NSLog(@"%@",[receivedArray objectAtIndex:0]);
     */
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"Testing";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rssFeed count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
