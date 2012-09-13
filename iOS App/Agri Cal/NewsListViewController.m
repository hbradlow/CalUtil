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
#import "NewsStoryViewController.h"

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
        self.splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,-64,320,480)];
        self.splashView.image = image;
        [self.view addSubview:self.splashView];
        [self performSelector:@selector(removeSplash) withObject:self afterDelay:1.5];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.5];
        [self.splashView setAlpha:0];
        [UIView commitAnimations];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).hasLoaded = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)removeSplash{
    [self.splashView removeFromSuperview];
}

- (void)loadRSS
{
    @try {
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
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *currentStory in receivedArray)
        {
            NewsStory *story = [[NewsStory alloc] init];
            story.title = [[currentStory objectForKey:@"title"] capitalizedString];
            story.summary = [[currentStory objectForKey:@"summary_detail"] objectForKey:@"value"];
            story.content = [[[currentStory objectForKey:@"content"] objectAtIndex:0] objectForKey:@"value"];
            story.published = [currentStory objectForKey:@"published"];
            story.published = [story.published substringToIndex:[story.published length]-5];
            [tempArray addObject:story];
        }
        self.rssFeed = tempArray;
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^(){[self.tableView reloadData];});
    }
    @catch (NSException *exception) {
        NSLog(@"Error loading news");
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if ([self.rssFeed count])
    {
        cell.textLabel.text = [[self.rssFeed objectAtIndex:indexPath.row] title];
        cell.detailTextLabel.text = [[self.rssFeed objectAtIndex:indexPath.row] published];
    } else {
        cell.textLabel.text = @"Loading news...";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"story" sender:[NSNumber numberWithInteger:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"story"])
    {
        ((NewsStoryViewController*)[segue destinationViewController]).story = [self.rssFeed objectAtIndex:[sender integerValue]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX([self.rssFeed count], 1);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
