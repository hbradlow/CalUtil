#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize username;
@synthesize password;
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
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"CalNet login";
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    NSString *titleText = @"";
    switch (indexPath.row) {
        case 0:
            titleText = @"Username";
            break;
        default:
            titleText = @"Password";
            break;
    }
    cell.textLabel.text = titleText;
    cell.detailTextLabel.text = @"hello";
    return cell;
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
