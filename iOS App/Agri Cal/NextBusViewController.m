//
//  NextBusViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 8/30/12.
//
//

#import "NextBusViewController.h"

@interface NextBusViewController ()

@end

@implementation NextBusViewController
@synthesize tableView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.annotation.title;
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:kTitleAdjustment forBarMetrics:UIBarMetricsDefault];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LineCell"];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    NSDictionary *currentLine = [self.lines objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentLine objectForKey:@"title"];
    cell.detailTextLabel.text = @"Loading next departure times";
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            [self updateTimes:self.annotation.stopID withTag:[currentLine objectForKey:@"tag"] atIndex:indexPath.row];
        });
    return cell;
}

- (void)updateTimes:(int)extension withTag:(NSString*)tag atIndex:(int)index
{
     @try {   
    NSString *queryString = [NSString stringWithFormat:@"%@/api/bus_stop/predictions/%i/%@", ServerURL, extension, tag];
    NSURL *requestURL = [NSURL URLWithString:queryString];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                 returningResponse:&response
                                                             error:&error];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];
    dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
    dispatch_async(updateUIQueue, ^{
        NSString *subtitle = [arr componentsJoinedByString:@", "];
        subtitle = [subtitle stringByAppendingString:@" minutes"];
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

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
