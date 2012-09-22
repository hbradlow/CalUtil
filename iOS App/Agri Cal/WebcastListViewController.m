//
//  WebcastListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import "WebcastListViewController.h"
#import "WebcastViewController.h"

@interface WebcastListViewController ()

@end

@implementation WebcastListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webcasts = [[NSMutableArray alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadWebcasts) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Updating webcasts"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.refreshControl beginRefreshing];
    [self loadWebcasts];
}

- (void)loadWebcasts
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        
        @try {
            NSString *queryString = [NSString stringWithFormat:@"%@/app_data/webcast/?format=json&course=%@", ServerURL, self.courseID];
            NSURL *requestURL = [NSURL URLWithString:queryString];
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
            
            NSData *receivedData;
            receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                 returningResponse:&response
                                                             error:&error];
            
            NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];
            
            NSArray *arr = [receivedDict objectForKey:@"objects"];
            
            NSMutableArray *tempWebcasts = [[NSMutableArray alloc] init];
            
            for (NSDictionary *currentWebcast in arr)
            {
                Webcast *newCast = [[Webcast alloc] init];
                newCast.url = [currentWebcast objectForKey:@"url"];
                newCast.number = [currentWebcast objectForKey:@"number"];
                [tempWebcasts addObject:newCast];
            }
            self.webcasts = tempWebcasts;
            [self.webcasts sortUsingComparator:(NSComparator)^(Webcast *obj1, Webcast *obj2){
                return [obj1.number compare:obj2.number options:NSNumericSearch];
            }];
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^(){[self.refreshControl endRefreshing];[self.tableView reloadData];});
        }
        @catch (NSException *exception) {
            NSLog(@"Error when loading webcast lists");
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^(){[self.refreshControl endRefreshing];});
        }
    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.webcasts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Lecture %@",[[self.webcasts objectAtIndex:indexPath.row] number]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"view" sender:tableView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebcastViewController *destination = [segue destinationViewController];
    destination.url = ((Webcast*)[self.webcasts objectAtIndex:[self.tableView indexPathForSelectedRow].row]).url;
}

@end
