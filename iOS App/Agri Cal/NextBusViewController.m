//
//  NextBusViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 8/30/12.
//
//

#import "NextBusViewController.h"
#import "CUTableViewCell.h"

@interface NextBusViewController ()

@end

@implementation NextBusViewController
@synthesize tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateAllTimes) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Times are refreshed automatically every minute"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.annotation.title;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:kTitleAdjustment forBarMetrics:UIBarMetricsDefault];
    self.timer = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(updateAllTimes) userInfo:nil repeats:YES];
    [self.timer fire];
    [self updateAllTimes];  
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lines count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LineCell"];
    if (!cell)
    {
        cell = [[CUTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LineCell"];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    NSDictionary *currentLine = [self.lines objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentLine objectForKey:@"title"];
    cell.detailTextLabel.text = @"Loading next departure times";
    return cell;
}
- (void)updateAllTimes
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        for (int i = 0; i < [self.lines count]; i++)
        {
            NSDictionary *currentLine = [self.lines objectAtIndex:i];
            [self updateTimes:self.annotation.stopID withTag:[currentLine objectForKey:@"tag"] atIndex:i];
        }
        [self.refreshControl endRefreshing];
    });
}
- (void)updateTimes:(NSString*)extension withTag:(NSString*)tag atIndex:(int)index
{
    @try {
        NSString *queryString = [NSString stringWithFormat:@"%@/api/bus_stop/predictions/%@/%@", ServerURL, extension, tag];
        NSLog(@"%@", queryString);
        NSURL *requestURL = [NSURL URLWithString:queryString];
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                     returningResponse:&response
                                                                 error:&error];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^{
            NSString *subtitle = [arr componentsJoinedByString:@", "];
            subtitle = [subtitle stringByAppendingString:@" minutes"];
            if (![arr count])
                subtitle = @"--";
            [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]].detailTextLabel.text = subtitle;
        });
    }
    @catch (NSException *exception) {
        NSLog(@"Error when loading times");
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
