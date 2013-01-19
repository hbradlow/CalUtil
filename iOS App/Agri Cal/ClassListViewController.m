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
#import "CUTableViewCell.h"
#import "CUTableHeaderView.h"

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
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Updating course list"]];
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.courseLoader = [[DataLoader alloc] initWithUrlString:[NSString stringWithFormat:@"/app_data/course/?format=json&department=%@&semester=%@", self.departmentURL, self.departmentSeason]
                                                  andFilePath:[NSString stringWithFormat:@"%@kClassesPath", self.departmentSeason]
                                                 andDataArray:self.classes];
    [self loadCoursesForced:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
- (void)refresh
{
    [self loadCoursesForced:YES];
}
- (void)loadCoursesForced:(BOOL)forced
{
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        for (NSDictionary *currentClass in arr)
        {
            CalClass *newClass = [[CalClass alloc] init];
            newClass.title = [currentClass objectForKey:@"abbreviation"];
            newClass.availableSeats = [currentClass objectForKey:@"available_seats"];
            newClass.number = [currentClass objectForKey:@"number"];
            newClass.hasWebcast = [[currentClass objectForKey:@"webcast_flag"] boolValue];
            newClass.uniqueID = [currentClass objectForKey:@"id"];
            newClass.times = [currentClass objectForKey:@"location"];
            [self.classes addObject:newClass];
        }
        dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
        dispatch_async(updateUIQueue, ^(){[self.refreshControl endRefreshing];[self.tableView reloadData];});
    };
    if (forced)
        [self.courseLoader forceLoadWithCompletionBlock:block withData:nil];
    else
    {
        [self.courseLoader loadDataWithCompletionBlock:block];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
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
    NSString *title = @"Classes";
    label.text = title;
    
    [view addSubview:label];
    return view;
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
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
        cell = [[CUTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
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
