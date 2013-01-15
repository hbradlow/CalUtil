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
#import "CUTableHeaderView.h"
#import "CUTableViewCell.h"

#define kDepartmentData @"depdata"
#define kDepartmentURL [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/departments"]
#define kDepartmentKey @"depkey"
#define kIndividualClassPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/individualclasses"]
#define kIndividualKey @"indkey"
#define kIndividualData @"inddata"
#define kWaitListPath @"waitlisted"

static NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

@implementation DepartmentListViewController
@synthesize sessionSelector;


- (id)init
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    self = [st instantiateViewControllerWithIdentifier:@"schedule"];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.departments = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.enrolledCourses = [[NSMutableArray alloc] init];
    self.waitlistedCourses = [[NSMutableArray alloc] init];
    self.enrolledCoursesSu = [[NSMutableArray alloc] init];
    self.waitlistedCoursesSu = [[NSMutableArray alloc] init];
    self.enrolledCoursesFa = [[NSMutableArray alloc] init];
    self.waitlistedCoursesFa = [[NSMutableArray alloc] init];
    self.enrolledCoursesSp = [[NSMutableArray alloc] init];
    self.waitlistedCoursesSp = [[NSMutableArray alloc] init];
    
    self.departmentLoader = [[DataLoader alloc] initWithUrlString:@"/app_data/department/?format=json"
                                                      andFilePath:kDepartmentURL];
    [self loadDepartments:self.departmentLoader withArray:self.departments];
    
    self.waitlistLoaderFa = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule_waitlist/FL/"
                                                      andFilePath:[NSString stringWithFormat:@"%@FL",kWaitListPath]];
    self.classLoaderFa = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule/FL"
                                                   andFilePath:[NSString stringWithFormat:@"%@FL",kIndividualClassPath]];
    
    self.waitlistLoaderSp = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule_waitlist/SP/"
                                                      andFilePath:[NSString stringWithFormat:@"%@SP",kWaitListPath]];
    self.classLoaderSp = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule/SP"
                                                   andFilePath:[NSString stringWithFormat:@"%@SP",kIndividualClassPath]];
    
    self.waitlistLoaderSu = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule_waitlist/SU/"
                                                      andFilePath:[NSString stringWithFormat:@"%@SU",kWaitListPath]];
    self.classLoaderSu = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule/SU"
                                                   andFilePath:[NSString stringWithFormat:@"%@SU",kIndividualClassPath]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Loading courses and departments"]];
    [self refresh];
    [self.searchDisplayController.searchBar setHidden:NO];
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
}

- (void)refresh
{
    NSLog(@"refresh");
    NSInteger selectedIndex = [self.sessionSelector selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            [self refresh:self.classLoaderFa withArray:self.enrolledCoursesFa];
            [self refresh:self.waitlistLoaderFa withArray:self.waitlistedCoursesFa];
            break;
        case 1:
            [self refresh:self.classLoaderSp withArray:self.enrolledCoursesSp];
            [self refresh:self.waitlistLoaderSp withArray:self.waitlistedCoursesSp];
            break;
        case 2:
            [self refresh:self.classLoaderSu withArray:self.enrolledCoursesSu];
            [self refresh:self.waitlistLoaderSu withArray:self.waitlistedCoursesSu];
            break;
        default:
            break;
    }
}

- (void)refresh:(DataLoader*)loader withArray:(NSMutableArray*)array
{
    [self loadCourses:loader withArray:array];
}

- (void)loadCourses:loader withArray:(NSMutableArray*)array
{
    [array removeAllObjects];
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        for (NSDictionary *currentClass in arr)
        {
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
            [array addObject:newClass];
        }
    };
    
    NSData *requestBody = [[NSString stringWithFormat:@"username=%@&password=%@", [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]] dataUsingEncoding:NSUTF8StringEncoding];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [loader forceLoadWithCompletionBlock:block arrayToSave:array withData:requestBody];
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^(){
            [self.refreshControl endRefreshing];
            [self switchSession:self.sessionSelector];
        });
    });
}

- (void)loadDepartments:(DataLoader*)loader withArray:(NSMutableArray*)array
{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        for (NSDictionary *currentDep in arr)
        {
            Department *newDep = [[Department alloc] init];
            newDep.title = [[currentDep objectForKey:@"name"] capitalizedString];
            newDep.departmentID = [currentDep objectForKey:@"id"];
            [array addObject:newDep];
        }
        [array sortUsingComparator:(NSComparator)^(Department *obj1, Department *obj2){
            return [obj1.title caseInsensitiveCompare:obj2.title];
        }];
    };
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [loader loadDataWithCompletionBlock:block arrayToSave:array];
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        /* not working dispatch_async(updateUIQueue, ^(){[self.tableView reloadData];}); */
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
        return 28;
    else
        return 1;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]);
    CUTableHeaderView *view = [[CUTableHeaderView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    rect.origin.y += 1;
    rect.origin.x += 8;
    rect.size.height -= 2;
    rect.size.width -= 4;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = kAppBlueColor;
    label.backgroundColor = [UIColor clearColor];
    NSString *title = @"";
    if (tableView == self.tableView)
    {
        switch (section) {
            case 0:
                title = @"Your registered courses";
                break;
            case 1:
                title = @"Waitlisted courses";
                break;
            default:
                title = [alphabet substringWithRange:NSMakeRange(section-2, 1)];
        }
    }
    else
        title = @"Search results";
    label.text = title;
    
    [view addSubview:label];
    return view;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && ![self.enrolledCourses count])
        return 0;
    if (section == 1 && ![self.waitlistedCourses count])
        return 0;
    return 22;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        if (section == 0)
            return [self.enrolledCourses count];
        if (section == 1)
            return [self.waitlistedCourses count];
        else
        {
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"title BEGINSWITH[cd] %@",
                                            [alphabet substringWithRange:NSMakeRange(section-2, 1)]];
            if (self.departments && [self.departments count])
                return [[NSMutableArray arrayWithArray:[self.departments filteredArrayUsingPredicate:resultPredicate]] count];
            else return 0;
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
        cell = [[CUTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:kAppFontBold size:18];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    cell.imageView.image = nil;
    if (tableView == self.tableView)
    {
        if (indexPath.section == 0)
        {
            cell.textLabel.text = [[self.enrolledCourses objectAtIndex:indexPath.row] title];
            if ([[self.enrolledCourses objectAtIndex:indexPath.row] hasWebcast])
                cell.imageView.image = [UIImage imageNamed:@"monitor"];
            cell.detailTextLabel.text = [[self.enrolledCourses objectAtIndex:indexPath.row] times];
        }
        else if (indexPath.section == 1)
        {
            cell.textLabel.text = [[self.waitlistedCourses objectAtIndex:indexPath.row] title];
            if ([[self.waitlistedCourses objectAtIndex:indexPath.row] hasWebcast])
                cell.imageView.image = [UIImage imageNamed:@"monitor"];
            cell.detailTextLabel.text = [[self.waitlistedCourses objectAtIndex:indexPath.row] times];
        }
        else
        {
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"title BEGINSWITH[cd] %@",
                                            [alphabet substringWithRange:NSMakeRange(indexPath.section-2, 1)]];
            cell.textLabel.text = [[[NSMutableArray arrayWithArray:[self.departments filteredArrayUsingPredicate:resultPredicate]] objectAtIndex:indexPath.row] title];
            cell.detailTextLabel.text = @"";
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
    if ([[segue identifier] isEqualToString:@"department"])
    {
        ClassListViewController *viewController = [segue destinationViewController];
        viewController.title = [table cellForRowAtIndexPath:[table indexPathForSelectedRow]].textLabel.text;
        if (table == self.tableView)
        {
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"title BEGINSWITH[cd] %@",
                                            [alphabet substringWithRange:NSMakeRange(indexPath.section-2, 1)]];
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
        NSArray *selectedCourse = nil;
        if (indexPath.section == 0)
            selectedCourse = self.enrolledCourses;
        else
            selectedCourse = self.waitlistedCourses;
        classViewController.currentClass = [selectedCourse objectAtIndex:indexPath.row];
        classViewController.title = [[selectedCourse objectAtIndex:indexPath.row] title];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Loading..."])
        return;
    
    if (tableView == self.tableView && indexPath.section > 1)
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
    return index+1;
}

- (void)viewDidUnload {
    [self setSessionSelector:nil];
    [super viewDidUnload];
}
- (IBAction)switchSession:(id)sender {
    switch ([self.sessionSelector selectedSegmentIndex]) {
        case 0:
            self.enrolledCourses = [[NSMutableArray alloc] initWithArray:self.enrolledCoursesFa];
            self.waitlistedCourses = [[NSMutableArray alloc] initWithArray:self.waitlistedCoursesFa];
            break;
        case 1:
            self.enrolledCourses = [[NSMutableArray alloc] initWithArray:self.enrolledCoursesSp];
            self.waitlistedCourses = [[NSMutableArray alloc] initWithArray:self.waitlistedCoursesSp];
            break;
        case 2:
            self.enrolledCourses = [[NSMutableArray alloc] initWithArray:self.enrolledCoursesSu];
            self.waitlistedCourses = [[NSMutableArray alloc] initWithArray:self.waitlistedCoursesSu];
        default:
            break;
    }
    NSLog(@"reloading tableview");
    [self.tableView reloadData];
}
@end
