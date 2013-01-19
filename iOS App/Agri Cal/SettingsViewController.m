#import "SettingsViewController.h"
#import "CUMenuTextField.h"
#import "CUSettingsHeader.h"

#define kUsernameIndex 1
#define kInfoIndex 0 
#define kCalIndex 2
#define kMealIndex 3
#define kBababIndex 4

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
    [self.navigationBar  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithWhite:0.75 alpha:1],UITextAttributeTextColor,[UIColor clearColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset ,[UIFont fontWithName:kAppFont size:20.0],UITextAttributeFont, nil]];
    self.tapRecognizer = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
    dispatch_async(queue, ^(){
        [self loadBalances];
    });
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kInfoIndex] animated:NO scrollPosition:UITableViewScrollPositionTop];
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
    if (section == kUsernameIndex)
        return 2;
    else if (section == kInfoIndex)
        return 5;
    else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
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
        case kUsernameIndex:
            label.text = @"CalNet login";
            break;
        case kCalIndex:
            label.text = @"Cal1Card balance";
            break;
        case kMealIndex:
            label.text = @"Mealpoints";
            break;
        case kInfoIndex:
            label.text = @"Information";
            break;
        default:
            label.text = @"Bear's Lair";
            break;
    }
    [view addSubview:label];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == kUsernameIndex)
    {
        cell = [[CUMenuCellViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textcell"];
        UITextField *textField = [[CUMenuTextField alloc] initWithFrame:CGRectMake(10, 10, 312, cell.frame.size.height-16)];
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        [textField setFont:[UIFont fontWithName:kAppFont size:18]];
        [textField setEnabled:YES];
        textField.delegate = self;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        if (indexPath.row==0)
        {
            self.username = textField;
            textField.placeholder = @"Username";
            textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            [cell addSubview:textField];
        }
        if (indexPath.row==1)
        {
            self.password = textField;
            textField.placeholder = @"Password";
            textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
            [cell addSubview:textField];
            textField.secureTextEntry = YES;
        }
    }
    else if (indexPath.section == kInfoIndex)
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
    else if (indexPath.section == kMealIndex || indexPath.section == kCalIndex)
    {
        cell = [[CUMenuCellViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        cell.textLabel.font = [UIFont fontWithName:kAppFont size:18];
        switch (indexPath.section) {
            case kCalIndex:
                if ([[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance] && ![[[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance] isEqualToString:@""])
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@  ",[[NSUserDefaults standardUserDefaults] objectForKey:kCalBalance]];
                }
                else
                {
                    cell.textLabel.text = @"N/A  ";
                }
                break;
            case kMealIndex:
                if ([[NSUserDefaults standardUserDefaults] objectForKey:kMealpoints] && ![[[NSUserDefaults standardUserDefaults] objectForKey:kMealpoints] isEqualToString:@""])
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@  ",[[NSUserDefaults standardUserDefaults] objectForKey:kMealpoints]];
                }
                else
                {
                    cell.textLabel.text = @"N/A  ";
                }
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
        cell.textLabel.text = @"Buy a Bear a Beer";
    }
    return cell;
}

- (void)hide
{
    [[NSUserDefaults standardUserDefaults] setValue:self.username.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:self.password.text forKey:@"password"];
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kInfoIndex || indexPath.section == kBababIndex)
        return YES;
    else return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kInfoIndex)
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
        [revealController setFrontViewController:controller animated:YES];
    }
    if (indexPath.section == kBababIndex)
    {
        [self hide];
        UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
        UIViewController *controller;
        if (IS_IPHONE5)
            controller = [st instantiateViewControllerWithIdentifier:@"BaBaB5"];
        else
            controller = [st instantiateViewControllerWithIdentifier:@"BaBaB4"];
        [revealController setFrontViewController:controller animated:YES];
    }
}

- (void)loadBalances
{
    @try {
        NSString *queryString = [NSString stringWithFormat:@"%@/api/balance/?username=%@&password=%@", ServerURL, [[NSUserDefaults standardUserDefaults] objectForKey:kUserName], [[NSUserDefaults standardUserDefaults] objectForKey:kPassword]];
        NSURL *requestURL = [NSURL URLWithString:queryString];
        NSError *error = nil;
        NSURLRequest *jsonRequest = [NSURLRequest requestWithURL:requestURL];
        NSURLResponse *response = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:jsonRequest
                                                     returningResponse:&response
                                                                 error:&error];
        
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONWritingPrettyPrinted error:nil];
        
        if (dict)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"meal_points"] forKey:kMealpoints];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"balance"] forKey:kCalBalance];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
        });
    }
    @catch (NSException *exception) {
        [[NSUserDefaults standardUserDefaults] setObject:@"N/A" forKey:kMealpoints];
        [[NSUserDefaults standardUserDefaults] setObject:@"N/A" forKey:kCalBalance];
        NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:self.tapRecognizer];
    if (textField == self.password)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        CGRect frame = self.tableView.frame;
        frame.origin.y -= 22;
        [UIView beginAnimations:@"tableview" context:nil];
        self.tableView.frame = frame;
        [UIView commitAnimations];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.username)
        [[NSUserDefaults standardUserDefaults] setValue:self.username.text forKey:@"username"];
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:self.password.text forKey:@"password"];
        CGRect frame = self.tableView.frame;
        frame.origin.y += 22;
        [UIView beginAnimations:@"tableview" context:nil];
        self.tableView.frame = frame;
        [UIView commitAnimations];
    }
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
