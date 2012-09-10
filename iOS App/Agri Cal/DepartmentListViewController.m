//
//  DepartmentListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//
#warning Add abbreviation to departments
#import "DepartmentListViewController.h"
#import "ClassListViewController.h"
#import "ClassViewController.h"
#import "CalClass.h"

#define kDepartmentData @"depdata"
#define kDepartmentURL [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/departments"]
#define kDepartmentKey @"depkey"
#define kIndividualClassPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/individualclasses"]
#define kIndividualKey @"indkey"
#define kIndividualData @"inddata"

static NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

@implementation DepartmentListViewController
@synthesize sessionSelector;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [self loadCourses];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.departments = [[NSMutableArray alloc] init];
    self.enrolledCourses = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    NSData *departmentData;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kDepartmentKey])
    {
        departmentData = [[NSMutableData alloc]initWithContentsOfFile:kDepartmentURL];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:departmentData];
        self.departments = [unarchiver decodeObjectForKey:kDepartmentData];
        [unarchiver finishDecoding];
    }
    if (!departmentData)
    {
        dispatch_async(queue, ^{
            [self loadDepartments];
        });
    }
    NSData *calData;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIndividualKey])
    {
        calData = [[NSMutableData alloc]initWithContentsOfFile:kIndividualClassPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:calData];
        self.enrolledCourses = [unarchiver decodeObjectForKey:kIndividualData];
        [unarchiver finishDecoding];
    }
    
    dispatch_async(queue, ^{
        [self loadCourses];
    });
}

- (void)loadCourses
{
    NSString *queryString = [NSString stringWithFormat:@"%@/personal_schedule/?username=%@&password=%@", ServerURL, [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]];
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
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *currentClass in arr)
    {
        CalClass *newClass = [[CalClass alloc] init];
        newClass.title = [currentClass objectForKey:@"abbreviation"];
        newClass.times = [currentClass objectForKey:@"days"];
        newClass.instructor = [currentClass objectForKey:@"instructor"];
        newClass.enrolledLimit = [currentClass objectForKey:@"limit"];
        newClass.enrolled = [currentClass objectForKey:@"enrolled"];
        newClass.availableSeats = [currentClass objectForKey:@"available_seats"];
        newClass.units = [currentClass objectForKey:@"units"];
        newClass.waitlist = [currentClass objectForKey:@"waitlist"];
        newClass.number = [currentClass objectForKey:@"number"];
        newClass.hasWebcast = [[currentClass objectForKey:@"webcast_flag"] boolValue];
        newClass.uniqueID = [currentClass objectForKey:@"id"];
        [tempArray addObject:newClass];
    }
    self.enrolledCourses = tempArray;
    dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
    dispatch_async(updateUIQueue, ^(){[self.tableView reloadData];});
}

- (void)loadDepartments
{
    NSString *queryString = [NSString stringWithFormat:@"%@/api/department/?format=json", ServerURL];
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
    
    NSMutableArray *tempDepartments = [[NSMutableArray alloc] init];
    
    for (NSDictionary *currentDep in arr)
    {
        Department *newDep = [[Department alloc] init];
        newDep.title = [currentDep objectForKey:@"name"];
        newDep.departmentID = [currentDep objectForKey:@"id"];
        [tempDepartments addObject:newDep];
    }
    self.departments = tempDepartments;
    [self.departments sortUsingComparator:(NSComparator)^(Department *obj1, Department *obj2){
        return [obj1.title caseInsensitiveCompare:obj2.title];
    }];
    [self saveDepartments];
    NSLog(@"loaded departments");
    dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
    dispatch_async(updateUIQueue, ^(){[self.tableView reloadData];});
}

- (void)saveDepartments
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.departments forKey:kDepartmentData];
    [archiver finishEncoding];
    [data writeToFile:kDepartmentURL atomically:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDepartmentKey];
}

- (void)saveCourses
{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.departments forKey:kIndividualData];
    [archiver finishEncoding];
    [data writeToFile:kIndividualClassPath atomically:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIndividualKey];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
        return 27;
    else
        return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        switch (section) {
            case 0:
                return @"Your registered courses";
            default:
                return [alphabet substringWithRange:NSMakeRange(section-1, 1)];
        }
    }
    else
        return @"Search results";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        if (section == 0)
            return [self.enrolledCourses count];
        else
        {
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"title BEGINSWITH[cd] %@",
                                            [alphabet substringWithRange:NSMakeRange(section-1, 1)]];
            return [[NSMutableArray arrayWithArray:[self.departments filteredArrayUsingPredicate:resultPredicate]] count];
        }
    }
    else
        return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (tableView == self.tableView)
    {
        if (indexPath.section == 0)
            cell.textLabel.text = [[self.enrolledCourses objectAtIndex:indexPath.row] title];
        else
        {
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"title BEGINSWITH[cd] %@",
                                            [alphabet substringWithRange:NSMakeRange(indexPath.section-1, 1)]];
            cell.textLabel.text = [[[NSMutableArray arrayWithArray:[self.departments filteredArrayUsingPredicate:resultPredicate]] objectAtIndex:indexPath.row] title];
        }
    }
    else
        cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] title];
    
    return cell;
}

#pragma mark - UISearchDisplayController delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[cd] %@",
                                    searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.departments filteredArrayUsingPredicate:resultPredicate]];
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
    UITableView *table = (UITableView*)sender;
    NSIndexPath *indexPath = [table indexPathForSelectedRow];
    NSLog(@"performing segue with id: %@", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"department"])
    {
        ClassListViewController *viewController = [segue destinationViewController];
        viewController.title = [table cellForRowAtIndexPath:[table indexPathForSelectedRow]].textLabel.text;
        if (table == self.tableView)
        {
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"title BEGINSWITH[cd] %@",
                                            [alphabet substringWithRange:NSMakeRange(indexPath.section-1, 1)]];
            NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[self.departments filteredArrayUsingPredicate:resultPredicate]];
            viewController.departmentURL = [[sectionArray objectAtIndex:indexPath.row] departmentID];
        }
        else
        {
            viewController.departmentURL = [[self.searchResults objectAtIndex:indexPath.row] departmentID];
        }
    }
    else
    {
        ClassViewController *classViewController = [segue destinationViewController];
        classViewController.currentClass = [self.enrolledCourses objectAtIndex:indexPath.row];
        classViewController.title = [[self.enrolledCourses objectAtIndex:indexPath.row] title];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at indexpath %i and %i", indexPath.row, tableView == self.tableView);
    if (tableView == self.tableView && indexPath.section)
        [self performSegueWithIdentifier:@"department" sender:tableView];
    else if (tableView != self.tableView)
        [self performSegueWithIdentifier:@"department" sender:tableView];
    else
        [self performSegueWithIdentifier:@"Course" sender:tableView];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSRange theRange = {0, 1};
    NSMutableArray * array = [NSMutableArray array];
    for ( NSInteger i = 0; i < [alphabet length]; i++) {
        theRange.location = i;
        [array addObject:[alphabet substringWithRange:theRange]];
    }
    [array insertObject:@"*" atIndex:0];
    return array;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString
                                                                             *)title atIndex:(NSInteger)index {
    return index;
}

- (void)viewDidUnload {
    [self setSessionSelector:nil];
    [super viewDidUnload];
}
@end
