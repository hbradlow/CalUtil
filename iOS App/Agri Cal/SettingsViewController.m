#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize username;
@synthesize password;

- (id)init
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    self = [st instantiateViewControllerWithIdentifier:@"settings"];
    [self.tableView setUserInteractionEnabled:YES];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.username.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    self.password.text = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    [self.loginLabel setFont:[UIFont fontWithName:kAppFont size:40]];
}
- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [self setLoginLabel:nil];
    [self setSaveButton:nil];
    [self setNavigationBar:nil];
    [super viewDidUnload];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"save"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:self.username.text forKey:kUserName];
        [[NSUserDefaults standardUserDefaults] setValue:password.text forKey:kPassword];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else
        return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{ return nil;}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
        case 1:
            return @"Campus Information";
    }
    return @"";
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    int x = cell.textLabel.frame.origin.x;
    int y = cell.textLabel.frame.origin.y;
    NSLog(@"%i,%i", x,y);
    if (indexPath.section == 0)
    {
        cell = [[CUMenuCellViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textcell"];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(4, 10, 312, cell.frame.size.height-16)];
        textField.backgroundColor = [UIColor clearColor];
        [textField setEnabled:YES];
        textField.delegate = self;
        if (indexPath.row==0)
        {
            self.username = textField;
            textField.placeholder = @"Username";
            [cell addSubview:textField];
        }
        if (indexPath.row==1)
        {
            self.password = textField;
            textField.placeholder = @"Password";
            [cell addSubview:textField];
        }
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Maps";
                if ([[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance] && ![[[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance] isEqualToString:@""])
                {
                    NSLog(@"-%@",[[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance]);
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  ",[[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance]];
                }
                else
                {
                    NSLog(@".");
                    cell.detailTextLabel.text = @"N/A  ";
                }
                break;
            case 1:
                cell.textLabel.text = @"Dining";
                break;
            case 2:
                cell.textLabel.text = @"Schedule";
                break;
            case 3:
                cell.textLabel.text = @"Information";
                break;
            case 4:
                cell.textLabel.text = @"News";
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)hide
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        [self hide];
        RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
        UIViewController *controller;
        switch (indexPath.row) {
            case 0:
                if (revealController.mapController)
                    controller = revealController.mapController;
                else
                {
                    controller = [[MapViewController alloc] init];
                    revealController.mapController = (MapViewController*)controller;
                }
                break;
            case 1:
                if (revealController.diningController)
                    controller = revealController.diningController;
                else
                {
                    controller = [[DiningCommonListViewController alloc] init];
                    revealController.diningController = (DiningCommonListViewController*)controller;
                }
                break;
            case 2:
                if (revealController.departmentController)
                    controller = revealController.departmentController;
                else
                {
                    controller = [[DepartmentListViewController alloc] init];
                    revealController.departmentController = (DepartmentListViewController*)controller;
                }
                break;
            case 3:
                if (revealController.infoController)
                    controller = revealController.infoController;
                else
                {
                    controller = [[InfoViewController alloc] init];
                    revealController.infoController = (InfoViewController*)controller;
                }
                break;
            case 4:
                if (revealController.newsController)
                {
                    NSLog(@"existed");
                    controller = revealController.newsController;
                }
                else
                {
                    controller = [[NewsListViewController alloc] init];
                    revealController.newsController = (NewsListViewController*)controller;
                }
                break;
            default:
                break;
        }
        [revealController setFrontViewController:controller animated:NO];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
