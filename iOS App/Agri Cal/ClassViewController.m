//
//  ClassViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/7/12.
//
//

#import "ClassViewController.h"
#import "WebcastListViewController.h"

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.sections = [[NSMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [self loadSections];
    });
    self.navigationItem.backBarButtonItem.title = @"Back";
    
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:kTitleAdjustment forBarMetrics:UIBarMetricsDefault];
}

- (void)loadSections
{
    @try {
        NSString *queryString = [NSString stringWithFormat:@"%@/app_data/section/?format=json&course=%@", ServerURL, self.currentClass.uniqueID];
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
        for (NSDictionary *currentClass in arr)
        {
            CalClass *newClass = [[CalClass alloc] init];
            newClass.title = [currentClass objectForKey:@"section"];
            newClass.times = [currentClass objectForKey:@"location"];
            newClass.instructor = [currentClass objectForKey:@"instructor"];
            newClass.enrolledLimit = [currentClass objectForKey:@"limit"];
            newClass.enrolled = [currentClass objectForKey:@"enrolled"];
            newClass.availableSeats = [currentClass objectForKey:@"available_seats"];
            newClass.units = [currentClass objectForKey:@"units"];
            newClass.waitlist = [currentClass objectForKey:@"waitlist"];
            newClass.number = [currentClass objectForKey:@"number"];
            newClass.hasWebcast = [[currentClass objectForKey:@"webcast_flag"] boolValue];
            newClass.uniqueID = [currentClass objectForKey:@"id"];
            newClass.ccn = [currentClass objectForKey:@"ccn"];
            newClass.finalExamGroup = [currentClass objectForKey:@"exam_group"];
            [self.sections addObject:newClass];
        }
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^(){[self.tableView reloadData];});
    }
    @catch (NSException *exception) {
        NSLog(@"Error when loading list of classes");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section)
        return 9;
    else
        return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CalClass *currentClass;
    if (indexPath.section == 0)
        currentClass = self.currentClass;
    else
        currentClass = [self.sections objectAtIndex:indexPath.section-1];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Title";
            if (indexPath.section)
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Dis %@", currentClass.title];
            else
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", currentClass.number, currentClass.title];
            break;
        case 1:
            cell.textLabel.text = @"Instructor";
            cell.detailTextLabel.text = currentClass.instructor;
            break;
        case 2:
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = currentClass.times;
            break;
        case 3:
            cell.textLabel.text = @"CCN";
            cell.detailTextLabel.text = currentClass.ccn;
            break;
        case 4:
            cell.textLabel.text = @"Enrolled";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@",currentClass.enrolled, currentClass.enrolledLimit];
            break;
        case 5:
            cell.textLabel.text = @"Waitlist";
            cell.detailTextLabel.text = currentClass.waitlist;
            break;
        case 6:
            cell.textLabel.text = @"Final";
            cell.detailTextLabel.text = currentClass.finalExamGroup;
            break;
        case 7:
            cell.textLabel.text = @"Units";
            cell.detailTextLabel.text = currentClass.units;
            break;
        case 8:
            cell.textLabel.text = @"Webcast";
            cell.detailTextLabel.text = currentClass.hasWebcast ? @"Yes" : @"No";
            cell.accessoryType = currentClass.hasWebcast ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            cell.selectionStyle = currentClass.hasWebcast ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"number of sections %i", [self.sections count]);
    return 1 + [self.sections count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 9 && self.currentClass.hasWebcast)
    {
        [self performSegueWithIdentifier:@"webcast" sender:nil];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebcastListViewController *controller = [segue destinationViewController];
    controller.courseID = [self.currentClass uniqueID];
    controller.navigationItem.title = self.currentClass.title;
}

@end
