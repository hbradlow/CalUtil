//
//  NewsListViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/10/12.
//
//

#import "NewsListViewController.h"
#import "NewsStory.h"
#import "AppDelegate.h"
#import "NewsStoryViewController.h"
#import "CUTableViewCell.h"

#define MENU_WIDTH self.navigationController.view.frame.size.width*3/4
#define MENU_HEIGHT self.navigationController.view.frame.size.height

@implementation NewsListViewController

- (id)init
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    self = [st instantiateViewControllerWithIdentifier:@"news"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadRSS) forControlEvents:UIControlEventValueChanged];
    self.rssFeed = [[NSMutableArray alloc] init];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Updating news"]];
    [self.refreshControl beginRefreshing];
    self.isMenuHidden = YES;
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, MENU_WIDTH, MENU_HEIGHT)
                                                      style:UITableViewStylePlain];
    [self.menuTableView setUserInteractionEnabled:YES];
    [self.tabBarController.view addSubview:self.menuTableView];
    [self.tabBarController.view sendSubviewToBack:self.menuTableView];
    self.dataLoader = [[DataLoader alloc] initWithUrlString:@"/api/dailycal/" andFilePath:kNewsFilePath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadRSS];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)loadRSS
{
    [self.rssFeed removeAllObjects];
    void (^block) (NSMutableArray*) = ^(NSMutableArray* arr){
        [self.rssFeed removeAllObjects];
            for (NSDictionary *currentStory in arr)
            {
                NewsStory *story = [[NewsStory alloc] init];
                story.title = [[currentStory objectForKey:@"title"] capitalizedString];
                story.summary = [[currentStory objectForKey:@"summary_detail"] objectForKey:@"value"];
                story.content = [[[currentStory objectForKey:@"content"] objectAtIndex:0] objectForKey:@"value"];
                story.published = [currentStory objectForKey:@"published"];
                story.published = [story.published substringToIndex:[story.published length]-5];
                [self.rssFeed addObject:story];
            }
            dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
            dispatch_async(updateUIQueue, ^(){[self.refreshControl endRefreshing];[self.tableView reloadData];});
    };
    [self.dataLoader loadDataWithCompletionBlock:block arrayToSave:self.rssFeed];
    [self.dataLoader forceLoadWithCompletionBlock:block arrayToSave:self.rssFeed withData:nil];
    dispatch_queue_t updateUIQueue = dispatch_get_main_queue();
    dispatch_async(updateUIQueue, ^(){[self.refreshControl endRefreshing];[self.tableView reloadData];});
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[CUTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    if ([self.rssFeed count])
    {
        cell.textLabel.text = [[self.rssFeed objectAtIndex:indexPath.row] title];
        cell.detailTextLabel.text = [[self.rssFeed objectAtIndex:indexPath.row] published];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } else {
        cell.textLabel.text = @"Loading news...";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"story" sender:[NSNumber numberWithInteger:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"story"])
    {
        ((NewsStoryViewController*)[segue destinationViewController]).story = [self.rssFeed objectAtIndex:[sender integerValue]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rssFeed count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end
