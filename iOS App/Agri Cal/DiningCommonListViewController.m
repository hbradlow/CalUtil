//
//  DiningCommonListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import "DiningCommonListViewController.h"
#import "DishDetailsViewController.h"
#import "Menu.h"
#import "Dish.h"

#define kCrossroads 0
#define kCKC 1
#define kCafe3 2
#define kFoothill 3

@interface DiningCommonListViewController ()

@end

@implementation DiningCommonListViewController
@synthesize locationSelector;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locations = [[NSMutableArray alloc] init];
    self.locations = [NSMutableArray arrayWithArray:@[ @"",@"",@"",@"" ]];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMenus) forControlEvents:UIControlEventValueChanged];
    [self loadMenus];
    [self.refreshControl beginRefreshing];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Updating menus"]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
}
- (void)loadMenus
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        
        @try {
            
            NSString *queryString = [NSString stringWithFormat:@"%@/app_data/menu/?format=json", ServerURL];
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
            for (NSDictionary *currentMenus in arr)
            {
                NSDictionary *currentLocation = [currentMenus objectForKey:@"location"];
                
                NSString *locationName = [currentLocation objectForKey:@"name"];
                NSArray *breakfastMenu = [currentMenus objectForKey:@"breakfast_items"];
                NSArray *lunchMenu = [currentMenus objectForKey:@"lunch_items"];
                NSArray *dinnerMenu = [currentMenus objectForKey:@"dinner_items"];
                
                Menu *currentMenu = [[Menu alloc] init];
                
                for (NSDictionary *currentItem in breakfastMenu)
                {
                    Dish *currentDish = [[Dish alloc] init];
                    currentDish.name = [currentItem objectForKey:@"name"];
                    currentDish.type = [currentItem objectForKey:@"type"];
                    currentDish.nutritionURL = [currentItem objectForKey:@"id"];
                    [currentMenu.breakfast addObject:currentDish];
                }
                
                for (NSDictionary *currentItem in lunchMenu)
                {
                    Dish *currentDish = [[Dish alloc] init];
                    currentDish.name = [currentItem objectForKey:@"name"];
                    currentDish.type = [currentItem objectForKey:@"type"];
                    currentDish.nutritionURL = [currentItem objectForKey:@"id"];
                    [currentMenu.lunch addObject:currentDish];
                }
                
                for (NSDictionary *currentItem in dinnerMenu)
                {
                    Dish *currentDish = [[Dish alloc] init];
                    currentDish.name = [currentItem objectForKey:@"name"];
                    currentDish.type = [currentItem objectForKey:@"type"];
                    currentDish.nutritionURL = [currentItem objectForKey:@"id"];
                    [currentMenu.dinner addObject:currentDish];
                }
                if ([locationName isEqualToString:@"crossroads"])
                {
                    [self.locations replaceObjectAtIndex:kCrossroads withObject:currentMenu];
                }
                else if ([locationName isEqualToString:@"cafe3"])
                {
                    [self.locations replaceObjectAtIndex:kCafe3 withObject:currentMenu];
                }
                else if ([locationName isEqualToString:@"ckc"])
                {
                    [self.locations replaceObjectAtIndex:kCKC withObject:currentMenu];
                }
                else if ([locationName isEqualToString:@"foothill"])
                {
                    [self.locations replaceObjectAtIndex:kFoothill withObject:currentMenu];
                }
            }
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^(){[self.refreshControl endRefreshing];[self.tableView reloadData];});
        }
        @catch (NSException *exception) {
            NSLog(@"Error when loading menus");
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^(){[self.refreshControl endRefreshing];});
        }
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger selectedIndex = [self.locationSelector selectedSegmentIndex];
    if ([[self.locations objectAtIndex:selectedIndex] class] != [Menu class])
        return 0;
    Menu *menu = [self.locations objectAtIndex:[self.locationSelector selectedSegmentIndex]];
    switch (section) {
        case 0:
            return [menu.breakfast count];
        case 1:
            return [menu.lunch count];
        case 2:
            return [menu.dinner count];
        default:
            break;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Breakfast";
        case 1:
            return @"Lunch";
        case 2:
            return @"Dinner";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Menu *menu = [self.locations objectAtIndex:[self.locationSelector selectedSegmentIndex]];
    if ([menu isKindOfClass:[Menu class]])
    {
        NSArray *currentMeal;
        switch (indexPath.section) {
            case 0:
                currentMeal = menu.breakfast;
                break;
            case 1:
                currentMeal = menu.lunch;
                break;
            case 2:
                currentMeal = menu.dinner;
            default:
                break;
        }
        
        cell.textLabel.text = ((Dish*)[currentMeal objectAtIndex:indexPath.row]).name;
        cell.detailTextLabel.text = ((Dish*)[currentMeal objectAtIndex:indexPath.row]).type;
    }
    else
    {
        cell.textLabel.text = @"Loading menu...";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Loading menu..."])
        return;
    [self performSegueWithIdentifier:@"details" sender:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath*)sender;
    Menu *menu = [self.locations objectAtIndex:[self.locationSelector selectedSegmentIndex]];
    NSArray *currentMeal;
    switch (indexPath.section) {
        case 0:
            currentMeal = menu.breakfast;
            break;
        case 1:
            currentMeal = menu.lunch;
            break;
        case 2:
            currentMeal = menu.dinner;
        default:
            break;
    }
    
    ((DishDetailsViewController*)[segue destinationViewController]).url = ((Dish*)[currentMeal objectAtIndex:indexPath.row]).nutritionURL;
}

- (IBAction)locationDidChange:(id)sender
{
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setLocationSelector:nil];
    [super viewDidUnload];
}
@end
