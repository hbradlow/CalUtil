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
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lines count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LineCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LineCell"];
    NSDictionary *currentLine = [self.lines objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentLine objectForKey:@"title"];
    cell.detailTextLabel.text = @"Loading next departure times";
    @try {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            [self updateTimes:self.annotation.stopID withTag:[currentLine objectForKey:@"tag"] atIndex:indexPath.row];
        });
    }
    @catch (NSException *exception) {
        NSLog(@"Error when loading times");
    }
    return cell;
}

- (void)updateTimes:(int)extension withTag:(NSString*)tag atIndex:(int)index
{
    
    NSString *queryString = [NSString stringWithFormat:@"%@/bus_stop/predictions/%i/%@", ServerURL, extension, tag];
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

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
