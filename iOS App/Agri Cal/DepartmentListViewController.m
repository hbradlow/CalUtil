//
//  DepartmentListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import "DepartmentListViewController.h"
#import "ClassListViewController.h"

#define kDepartmentData @"depdata"
#define kDepartmentURL @"depurl"
#define kDepartmentKey @"depkey"

@implementation DepartmentListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.departments = [[NSMutableArray alloc] init];
    self.enrolledCourses = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDepartmentKey];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kDepartmentKey])
    {
        NSLog(@"loading departments");
        dispatch_async(queue, ^{
            [self loadDepartments];
        });
    }
    else
    {
        NSData *data = [[NSMutableData alloc]initWithContentsOfFile:kDepartmentURL];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.departments = [unarchiver decodeObjectForKey:kDepartmentData];
        [unarchiver finishDecoding];
    }
    
    dispatch_async(queue, ^{
        [self loadCourses];
    });
}

- (void)loadCourses
{
#warning Incomplete method
    return;
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
    
    for (NSDictionary *currentDep in arr)
    {
        Department *newDep = [[Department alloc] init];
        newDep.title = [currentDep objectForKey:@"name"];
        newDep.departmentID = [currentDep objectForKey:@"id"];
        [self.departments addObject:newDep];
    }
    [self.departments sortUsingComparator:(NSComparator)^(Department *obj1, Department *obj2){
        return [obj1.title caseInsensitiveCompare:obj2.title];
    }];
    [self saveDepartments];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
        return 2;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        if (section == 0)
            return [self.enrolledCourses count];
        else
            return [self.departments count];
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
    }
    
    if (tableView == self.tableView)
        cell.textLabel.text = [[self.departments objectAtIndex:indexPath.row] title];
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
    if ([[segue identifier] isEqualToString:@"department"])
    {
        ClassListViewController *viewController = [segue destinationViewController];
        UITableView *table = (UITableView*)sender;
        viewController.title = [table cellForRowAtIndexPath:[table indexPathForSelectedRow]].textLabel.text;
        if (table == self.tableView)
            viewController.departmentURL = [[self.departments objectAtIndex:[self.tableView indexPathForSelectedRow].row] departmentID];
        else
            viewController.departmentURL = [[self.searchResults objectAtIndex:[self.tableView indexPathForSelectedRow].row] departmentID];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"department" sender:tableView];
}

@end
