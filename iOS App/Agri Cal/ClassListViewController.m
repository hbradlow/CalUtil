//
//  ClassListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/7/12.
//
//

#import "ClassListViewController.h"
#import "CalClass.h"
#import "ClassViewController.h"

#define kClassesPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/course%@",self.departmentURL]]
#define kClassesData @"classdata"
#define kClassesKey self.departmentURL

@interface ClassListViewController ()

@end

@implementation ClassListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.classes = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    NSData *data;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kClassesKey])
    {
        data = [[NSMutableData alloc]initWithContentsOfFile:kClassesPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.classes = [unarchiver decodeObjectForKey:kClassesData];
        [unarchiver finishDecoding];
    }
    if (!data)
    {
        dispatch_async(queue, ^{
            [self loadCoursesWithExtension:[NSString stringWithFormat:@"app_data/course/?format=json&department=%@", self.departmentURL]];
        });
    }
    
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:kTitleAdjustment forBarMetrics:UIBarMetricsDefault];
}

- (void)loadCoursesWithExtension:(NSString*)extension
{
    @try {
        NSString *queryString = [NSString stringWithFormat:@"%@/%@", ServerURL,extension];
        NSLog(@"%@", queryString);
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
            NSLog(@"%@", currentClass);
            CalClass *newClass = [[CalClass alloc] init];
            newClass.title = [currentClass objectForKey:@"abbreviation"];
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
            [self.classes addObject:newClass];
        }
        
        if (!([[receivedDict objectForKey:@"meta"] objectForKey:@"next"] == [NSNull null]))
            [self loadCoursesWithExtension:[[receivedDict objectForKey:@"meta"] objectForKey:@"next"]];
        else
        {
            [self.classes sortUsingComparator:(NSComparator)^(CalClass *obj1, CalClass *obj2){
                return [obj1.number compare:obj2.number options:NSNumericSearch];
            }];
            [self saveCourses];
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^(){[self.tableView reloadData];});
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error when loading list of classes");
    }
}

- (void)saveCourses
{
    NSLog(@"saving courses to %@", kClassesPath);
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.classes forKey:kClassesData];
    [archiver finishEncoding];
    [data writeToFile:kClassesPath atomically:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kClassesKey];
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
    NSLog(@"number of rows %i", [self.classes count]);
    if (tableView == self.tableView)
        return MAX([self.classes count], 1);
    else
        return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    CalClass *theClass;
    @try {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (tableView == self.tableView)
            theClass = [self.classes objectAtIndex:indexPath.row];
        else
            theClass = [self.searchResults objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[theClass number], [theClass title]];
        cell.detailTextLabel.text = [theClass times];
        
        if (theClass.hasWebcast)
            cell.imageView.image = [UIImage imageNamed:@"monitor.png"];
        else
            cell.imageView.image = nil;
    }
    @catch (NSException *exception) {
        cell.textLabel.text = @"Loading...";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    @finally {
    }
    
    return cell;
}

#pragma mark - UISearchDisplayController delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"number contains[cd] %@ OR title contains[cd] %@",
                                    searchText, searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.classes filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"class"])
    {
        ClassViewController *viewController = [segue destinationViewController];
        UITableView *table = (UITableView*)sender;
        viewController.title = [table cellForRowAtIndexPath:[table indexPathForSelectedRow]].textLabel.text;
        if (table == self.tableView)
            viewController.currentClass = [self.classes objectAtIndex:[table indexPathForSelectedRow].row];
        else
            viewController.currentClass = [self.searchResults objectAtIndex:[table indexPathForSelectedRow].row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Loading..."])
        return;
    
    [self performSegueWithIdentifier:@"class" sender:tableView];
}

@end
