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

- (id)init
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    self = [st instantiateViewControllerWithIdentifier:@"dining"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locations = [[NSMutableArray alloc] init];
    self.locations = [NSMutableArray arrayWithArray:@[ @"",@"",@"",@"" ]];
    self.sectionTitles = [[NSMutableArray alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMenus) forControlEvents:UIControlEventValueChanged];
    [self loadMenus];
    [self.refreshControl beginRefreshing];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Updating menus"]];
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:MENU_IMAGE style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
	}
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
                NSString *timeSpan = [currentLocation objectForKey:@"timespan_string"];
                NSArray *breakfastMenu = [currentMenus objectForKey:@"breakfast_items"];
                NSArray *lunchMenu = [currentMenus objectForKey:@"lunch_items"];
                NSArray *dinnerMenu = [currentMenus objectForKey:@"dinner_items"];
                NSArray *lateNightMenu = [currentMenus objectForKey:@"late_night_items"];
                NSArray *brunchMenu = [currentMenus objectForKey:@"brunch_items"];
                
                Menu *currentMenu = [[Menu alloc] init];
                currentMenu.timeSpan = timeSpan;
                
                for (NSDictionary *currentItem in breakfastMenu)
                {
                    Dish *currentDish = [[Dish alloc] init];
                    currentDish.name = [currentItem objectForKey:@"name"];
                    currentDish.type = [currentItem objectForKey:@"type"];
                    currentDish.nutritionURL = [currentItem objectForKey:@"id"];
                    [currentMenu.breakfast addObject:currentDish];
                    if ([[currentLocation objectForKey:@"breakfast_times"] count])
                        currentMenu.breakfastTime = [[[currentLocation objectForKey:@"breakfast_times"] objectAtIndex:0] objectForKey:@"span"];
                }
                
                for (NSDictionary *currentItem in brunchMenu)
                {
                    Dish *currentDish = [[Dish alloc] init];
                    currentDish.name = [currentItem objectForKey:@"name"];
                    currentDish.type = [currentItem objectForKey:@"type"];
                    currentDish.nutritionURL = [currentItem objectForKey:@"id"];
                    [currentMenu.brunch addObject:currentDish];
                    if ([[currentLocation objectForKey:@"brunch_times"] count])
                        currentMenu.brunchTime = [[[currentLocation objectForKey:@"brunch_times"] objectAtIndex:0] objectForKey:@"span"];
                }
                
                for (NSDictionary *currentItem in lunchMenu)
                {
                    Dish *currentDish = [[Dish alloc] init];
                    currentDish.name = [currentItem objectForKey:@"name"];
                    currentDish.type = [currentItem objectForKey:@"type"];
                    currentDish.nutritionURL = [currentItem objectForKey:@"id"];
                    [currentMenu.lunch addObject:currentDish];
                    if ([[currentLocation objectForKey:@"lunch_times"]count])
                        currentMenu.lunchTime = [[[currentLocation objectForKey:@"lunch_times"] objectAtIndex:0] objectForKey:@"span"];
                }
                
                for (NSDictionary *currentItem in dinnerMenu)
                {
                    Dish *currentDish = [[Dish alloc] init];
                    currentDish.name = [currentItem objectForKey:@"name"];
                    currentDish.type = [currentItem objectForKey:@"type"];
                    currentDish.nutritionURL = [currentItem objectForKey:@"id"];
                    [currentMenu.dinner addObject:currentDish];
                    if ([[currentLocation objectForKey:@"dinner_times"] count])
                        currentMenu.dinnerTime = [[[currentLocation objectForKey:@"dinner_times"] objectAtIndex:0] objectForKey:@"span"];
                }
                
                for (NSDictionary *currentItem in lateNightMenu)
                {
                    Dish *currentDish = [[Dish alloc] init];
                    currentDish.name = [currentItem objectForKey:@"name"];
                    currentDish.type = [currentItem objectForKey:@"type"];
                    currentDish.nutritionURL = [currentItem objectForKey:@"id"];
                    [currentMenu.lateNight addObject:currentDish];
                    if ([[currentLocation objectForKey:@"latenight_times"] count])
                        currentMenu.lateNightTime = [[[currentLocation objectForKey:@"latenight_times"] objectAtIndex:0] objectForKey:@"span"];
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
            NSLog(@"Error when loading menus %@", exception);
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^(){[self.refreshControl endRefreshing];});
        }
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    int count = 0;
    Menu *currentMenu = [self.locations objectAtIndex:[self.locationSelector selectedSegmentIndex]];
    self.sectionTitles = [[NSMutableArray alloc] init];
    if ([currentMenu isKindOfClass:[Menu class]])
    {
        if ([currentMenu.breakfast count])
        {
            [self.sectionTitles addObject:@"Breakfast"];
            count++;
        }
        if ([currentMenu.brunch count])
        {
            [self.sectionTitles addObject:@"Brunch"];
            count++;
        }
        if ([currentMenu.lunch count])
        {
            [self.sectionTitles addObject:@"Lunch"];
            count++;
        }
        if ([currentMenu.dinner count])
        {
            [self.sectionTitles addObject:@"Dinner"];
            count++;
        }
        if ([currentMenu.lateNight count])
        {
            [self.sectionTitles addObject:@"Late Night"];
            count++;
        }
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger selectedIndex = [self.locationSelector selectedSegmentIndex];
    if ([[self.locations objectAtIndex:selectedIndex] class] != [Menu class])
        return 0;
    Menu *menu = [self.locations objectAtIndex:[self.locationSelector selectedSegmentIndex]];
    NSString *title = [self.sectionTitles objectAtIndex:section];
    if ([title isEqualToString:@"Breakfast"])
        return [menu.breakfast count];
    if ([title isEqualToString:@"Brunch"])
        return [menu.brunch count];
    if ([title isEqualToString:@"Lunch"])
        return [menu.lunch count];
    if ([title isEqualToString:@"Dinner"])
        return [menu.dinner count];
    if ([title isEqualToString:@"Late Night"])
        return [menu.lateNight count];
    
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [self.sectionTitles objectAtIndex:section];
    NSString *times = @"";
    Menu *menu = [self.locations objectAtIndex:[self.locationSelector selectedSegmentIndex]];
    if ([title isEqualToString:@"Breakfast"])
        times = menu.breakfastTime;
    if ([title isEqualToString:@"Brunch"])
        times = menu.brunchTime;
    if ([title isEqualToString:@"Lunch"])
        times = menu.lunchTime;
    if ([title isEqualToString:@"Dinner"])
        times = menu.dinnerTime;
    if ([title isEqualToString:@"Late Night"])
        times = menu.lateNightTime;
    return [NSString stringWithFormat:@"%@ Open: %@", [self.sectionTitles objectAtIndex:section], times];
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
        NSString *title = [self.sectionTitles objectAtIndex:indexPath.section];
        if ([title isEqualToString:@"Breakfast"])
            currentMeal = menu.breakfast;
        if ([title isEqualToString:@"Brunch"])
            currentMeal = menu.brunch;
        if ([title isEqualToString:@"Lunch"])
            currentMeal = menu.lunch;
        if ([title isEqualToString:@"Dinner"])
            currentMeal = menu.dinner;
        if ([title isEqualToString:@"Late Night"])
            currentMeal = menu.lateNight;
        
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
    NSString *title = [self.sectionTitles objectAtIndex:indexPath.section];
    if ([title isEqualToString:@"Breakfast"])
        currentMeal = menu.breakfast;
    if ([title isEqualToString:@"Brunch"])
        currentMeal = menu.brunch;
    if ([title isEqualToString:@"Lunch"])
        currentMeal = menu.lunch;
    if ([title isEqualToString:@"Dinner"])
        currentMeal = menu.dinner;
    if ([title isEqualToString:@"Late Night"])
        currentMeal = menu.lateNight;
    
    ((DishDetailsViewController*)[segue destinationViewController]).url = ((Dish*)[currentMeal objectAtIndex:indexPath.row]).nutritionURL;
}

- (IBAction)locationDidChange:(id)sender
{
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)viewDidUnload {
    [self setLocationSelector:nil];
    [super viewDidUnload];
}
@end
