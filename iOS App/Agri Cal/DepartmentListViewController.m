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
    self.enrolledCoursesSu = [[NSMutableArray alloc] init];
    self.waitlistedCoursesSu = [[NSMutableArray alloc] init];
    self.enrolledCoursesFa = [[NSMutableArray alloc] init];
    self.waitlistedCoursesFa = [[NSMutableArray alloc] init];
    self.enrolledCoursesSp = [[NSMutableArray alloc] init];
    self.waitlistedCoursesSp = [[NSMutableArray alloc] init];
    
    self.departmentLoader = [[DataLoader alloc] initWithUrlString:@"/app_data/department/?format=json"
                                                      andFilePath:kDepartmentURL
                                                     andDataArray:self.departments];
    [self loadDepartments:self.departmentLoader];
    
    self.waitlistLoaderFa = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule_waitlist/FL/"
                                                      andFilePath:[NSString stringWithFormat:@"%@FL",kWaitListPath]
                                                     andDataArray:self.waitlistedCoursesFa];
    self.classLoaderFa = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule/FL"
                                                   andFilePath:[NSString stringWithFormat:@"%@FL",kIndividualClassPath]
                                                  andDataArray:self.enrolledCoursesFa];
    
    self.waitlistLoaderSp = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule_waitlist/SP/"
                                                      andFilePath:[NSString stringWithFormat:@"%@SP",kWaitListPath]
                                                     andDataArray:self.waitlistedCoursesSp];
    self.classLoaderSp = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule/SP"
                                                   andFilePath:[NSString stringWithFormat:@"%@SP",kIndividualClassPath]
                                                  andDataArray:self.enrolledCoursesSp];
    
    self.waitlistLoaderSu = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule_waitlist/SU/"
                                                      andFilePath:[NSString stringWithFormat:@"%@SU",kWaitListPath]
                                                     andDataArray:self.enrolledCoursesSu];
    self.classLoaderSu = [[DataLoader alloc] initWithUrlString:@"/api/personal_schedule/SU"
                                                   andFilePath:[NSString stringWithFormat:@"%@SU",kIndividualClassPath]
                                                  andDataArray:self.waitlistedCoursesSu];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Loading courses and departments"]];
    [self.searchDisplayController.searchBar setHidden:NO];
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self loadCourses:self.classLoaderFa withArray:self.enrolledCoursesFa forced:YES];
        [self loadCourses:self.waitlistLoaderFa withArray:self.waitlistedCoursesFa forced:YES];
        [self loadCourses:self.classLoaderSp withArray:self.enrolledCoursesSp forced:YES];
        [self loadCourses:self.waitlistLoaderSp withArray:self.waitlistedCoursesSp forced:YES];
        [self loadCourses:self.classLoaderSu withArray:self.enrolledCoursesSu forced:YES];
        [self loadCourses:self.waitlistLoaderSu withArray:self.waitlistedCoursesSu forced:YES];
    });
}

- (NSMutableArray*)getCurrentCourseArray
{
    NSInteger selectedIndex = [self.sessionSelector selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            return self.enrolledCoursesFa;
        case 1:
            return self.enrolledCoursesSp;
        case 2:
            return self.enrolledCoursesSu;
        default:
            return nil;
    }
}
- (NSMutableArray*)getCurrentWaitlistArray
{
    NSInteger selectedIndex = [self.sessionSelector selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            return self.waitlistedCoursesFa;
        case 1:
            return self.waitlistedCoursesSp;
        case 2:
            return self.waitlistedCoursesSu;
        default:
            return nil;
    }
}

- (void)refresh
{
    [self.refreshControl beginRefreshing];
    NSInteger selectedIndex = [self.sessionSelector selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            [self loadCourses:self.classLoaderFa withArray:self.enrolledCoursesFa forced:YES];
            [self loadCourses:self.waitlistLoaderFa withArray:self.waitlistedCoursesFa forced:YES];
            break;
        case 1:
            [self loadCourses:self.classLoaderSp withArray:self.enrolledCoursesSp forced:YES];
            [self loadCourses:self.waitlistLoaderSp withArray:self.waitlistedCoursesSp forced:YES];
            break;
        case 2:
            [self loadCourses:self.classLoaderSu withArray:self.enrolledCoursesSu forced:YES];
            [self loadCourses:self.waitlistLoaderSu withArray:self.waitlistedCoursesSu forced:YES];
            break;
        default:
            break;
    }
}

- (void)loadCourses:loader withArray:(NSMutableArray*)array forced:(BOOL)forced
{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        if ([arr count])
            [array removeAllObjects];
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
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^(){
            [self.refreshControl endRefreshing];
            [self switchSession:self.sessionSelector];
        });
    };
    
    NSData *requestBody = [[NSString stringWithFormat:@"username=%@&password=%@", [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]] dataUsingEncoding:NSUTF8StringEncoding];
    if (forced)
        [loader forceLoadWithCompletionBlock:block withData:requestBody];
    else
        [loader loadDataWithCompletionBlock:block withData:requestBody];
}

- (void)loadDepartments:(DataLoader*)loader
{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        for (NSDictionary *currentDep in arr)
        {
            Department *newDep = [[Department alloc] init];
            newDep.title = [[currentDep objectForKey:@"name"] capitalizedString];
            newDep.departmentID = [currentDep objectForKey:@"id"];
            [self.departments addObject:newDep];
        }
        [self.departments sortUsingComparator:(NSComparator)^(Department *obj1, Department *obj2){
            return [obj1.title caseInsensitiveCompare:obj2.title];
        }];
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^(){[self.tableView reloadData];});
    };

    [loader loadDataWithCompletionBlock:block];
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
    if (self.tableView != tableView)
        return 0;
    if (section == 0 && ![[self getCurrentCourseArray] count])
        return 0;
    if (section == 1 && ![[self getCurrentWaitlistArray] count])
        return 0;
    return 22;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        if (section == 0)
            return [[self getCurrentCourseArray] count];
        if (section == 1)
            return [[self getCurrentWaitlistArray] count];
        else
        {
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"title BEGINSWITH[cd] %@",
                                            [alphabet substringWithRange:NSMakeRange(section-2, 1)]];
            if (self.departments && [self.departments count] > 0)
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
            NSMutableArray *enrolledCourses = [self getCurrentCourseArray];
            cell.textLabel.text = [[enrolledCourses objectAtIndex:indexPath.row] title];
            if ([[enrolledCourses objectAtIndex:indexPath.row] hasWebcast])
                cell.imageView.image = [UIImage imageNamed:@"monitor"];
            cell.detailTextLabel.text = [[enrolledCourses objectAtIndex:indexPath.row] times];
        }
        else if (indexPath.section == 1)
        {
            NSMutableArray *waitlistedCourses = [self getCurrentWaitlistArray];
            cell.textLabel.text = [[waitlistedCourses objectAtIndex:indexPath.row] title];
            if ([[waitlistedCourses objectAtIndex:indexPath.row] hasWebcast])
                cell.imageView.image = [UIImage imageNamed:@"monitor"];
            cell.detailTextLabel.text = [[waitlistedCourses objectAtIndex:indexPath.row] times];
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
        
        NSString *seasonString = @"";
        NSInteger selectedIndex = self.sessionSelector.selectedSegmentIndex;
        switch (selectedIndex) {
            case 0:
                seasonString = @"FA";
                break;
            case 1:
                seasonString = @"SP";
                break;
            case 2:
                seasonString = @"SU";
        }
        viewController.departmentSeason = seasonString;
        
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
            selectedCourse = [self getCurrentCourseArray];
        else
            selectedCourse = [self getCurrentWaitlistArray];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [self.waitlistLoaderFa save];
    [self.waitlistLoaderSu save];
    [self.waitlistLoaderSp save];
    [self.classLoaderFa save];
    [self.classLoaderSu save];
    [self.classLoaderSp save];
    [self.departmentLoader save];
    [super viewWillDisappear:animated];
    
}

- (void)viewDidUnload {
    [self setSessionSelector:nil];
    [super viewDidUnload];
}
- (IBAction)switchSession:(id)sender {
    [self.tableView reloadData];
}
@end
