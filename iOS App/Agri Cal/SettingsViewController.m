#import "SettingsViewController.h"
#import "CUMenuTextField.h"
#import "CUSettingsHeader.h"

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
    [self.navigationBar  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithWhite:0.75 alpha:1],UITextAttributeTextColor,[UIColor clearColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset ,[UIFont fontWithName:kAppFont size:20.0],UITextAttributeFont, nil]];
    self.tapRecognizer = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
}

- (void)dismissKeyboard
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapRecognizer];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else if (section < 3)
        return 1;
    else
        return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

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
    return 22;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]);
    CUSettingsHeader *view = [[CUSettingsHeader alloc] initWithFrame:rect];
    [view setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    rect.origin.y += 1;
    rect.origin.x += 8;
    rect.size.height -= 2;
    rect.size.width -= 4;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    switch (section) {
        case 0:
            label.text = @"CalNet login";
            break;
        case 1:
            label.text = @"Cal1Card balance";
            break;
        case 2:
            label.text = @"Mealpoints";
            break;
        case 3:
            label.text = @"Information";
            break;
    }
    [view addSubview:label];
    return view;
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
        UITextField *textField = [[CUMenuTextField alloc] initWithFrame:CGRectMake(10, 10, 312, cell.frame.size.height-16)];
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        [textField setFont:[UIFont fontWithName:kAppFont size:18]];
        [textField setEnabled:YES];
        textField.delegate = self;
        if (indexPath.row==0)
        {
            self.username = textField;
            textField.placeholder = @"Username";
            textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            NSLog(@"username %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]);
            [cell addSubview:textField];
        }
        if (indexPath.row==1)
        {
            self.password = textField;
            textField.placeholder = @"Password";
            textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
            NSLog(@"username %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]);            
            [cell addSubview:textField];
            textField.secureTextEntry = YES;
        }
    }
    else if (indexPath.section == 3)
    {
        cell = [[CUMenuCellViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        cell.textLabel.font = [UIFont fontWithName:kAppFont size:18];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Maps";
                cell.imageView.image = [UIImage imageNamed:@"world"];                
                break;
            case 1:
                cell.textLabel.text = @"Dining";
                cell.imageView.image = [UIImage imageNamed:@"crossroads"];
                break;
            case 2:
                cell.textLabel.text = @"Schedule";
                cell.imageView.image = [UIImage imageNamed:@"Calendar-Month"];                
                break;
            case 3:
                cell.textLabel.text = @"Information";
                cell.imageView.image = [UIImage imageNamed:@"Radio-Tower"];
                break;
            case 4:
                cell.textLabel.text = @"News";
                cell.imageView.image = [UIImage imageNamed:@"rss_64"];                
                break;
            default:
                break;
        }
    }
    else
    {
        cell = [[CUMenuCellViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        cell.textLabel.font = [UIFont fontWithName:kAppFont size:18];
        switch (indexPath.section) {
            case 1:
                if ([[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance] && ![[[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance] isEqualToString:@""])
                {
                    NSLog(@"-%@",[[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance]);
                    cell.textLabel.text = [NSString stringWithFormat:@"%@  ",[[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance]];
                }
                else
                {
                    NSLog(@".");
                    cell.textLabel.text = @"N/A  ";
                }
                break;
            case 2:
                if ([[NSUserDefaults standardUserDefaults] objectForKey:kMealpoints] && ![[[NSUserDefaults standardUserDefaults] objectForKey:kMealpoints] isEqualToString:@""])
                {
                    NSLog(@"-%@",[[NSUserDefaults standardUserDefaults] objectForKey:kMealpoints]);
                    cell.textLabel.text = [NSString stringWithFormat:@"%@  ",[[NSUserDefaults standardUserDefaults] objectForKey:kMealpoints]];
                }
                else
                {
                    NSLog(@".");
                    cell.textLabel.text = @"N/A  ";
                }
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 2)
        return YES;
    else return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 2)
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"here %i", textField == self.username);
    if (textField == self.username)
        [[NSUserDefaults standardUserDefaults] setValue:self.username.text forKey:@"username"];
    else
        [[NSUserDefaults standardUserDefaults] setValue:self.password.text forKey:@"password"];
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
