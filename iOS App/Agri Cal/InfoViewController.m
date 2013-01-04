#import "InfoViewController.h"

@implementation InfoViewController

- (id)init
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    self = [st instantiateViewControllerWithIdentifier:@"info"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titles = @[@[@"Bear Walk", @"UCPD Non-Emergency", @"Tang Center"], @[@"Cal Bears", @"Schedulebuilder", @"Tele-bears", @"Wikipedia"], @[@"Air Express Cab", @"Yellow Cab Express"]];
    self.detailTitles = @[@[@"510-642-9255", @"510-642-6760", @"510-642-2000"], @[@"http://www.calbears.com/", @"http://schedulebuilder.berkeley.edu/", @"http://telebears.berkeley.edu", @"http://en.wikipedia.org/wiki/University_of_California,_Berkeley"], @[@"510-485-4848", @"510-234-5555"]];
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
        UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [a1 setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)];
        [a1 addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [a1 setImage:[UIImage imageNamed:@"menubutton"] forState:UIControlStateNormal];
        UIBarButtonItem *random = [[UIBarButtonItem alloc] initWithCustomView:a1];
		self.navigationItem.leftBarButtonItem = random;
	}
}
/*
 The table view contains only static data so just handle
 selections depending on if the cell is a phone number or website.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titles count];
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Campus Safety";
        case 1:
            return @"Websites";
        case 2:
            return @"Transportation";
        default:
            return @"";
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert;
    if(indexPath.section == 1){
        alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Redirect to %@?", [tableView cellForRowAtIndexPath:indexPath].textLabel.text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    }
    else{
        alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Call %@?", [tableView cellForRowAtIndexPath:indexPath].textLabel.text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    }
    [alert show];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titles objectAtIndex:section] count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text = [[self.titles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[self.detailTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    else {
        if ([[[[alertView buttonTitleAtIndex:1] componentsSeparatedByString:@" "] objectAtIndex:0] isEqualToString:@"Redirect"])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text]];
        else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].detailTextLabel.text]]];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}
- (void)viewDidUnload {
    [self setNavigationBar:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
