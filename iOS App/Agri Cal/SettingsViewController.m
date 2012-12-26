#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize username;
@synthesize password;

- (id)init
{
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    self = [st instantiateViewControllerWithIdentifier:@"settings"];
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

-(UITableViewCell *)reuseTableViewCellWithIdentifier:(NSString *)identifier withIndexPath:(NSIndexPath *)indexPath {
    CGRect cellRectangle = CGRectMake (0, 10, 300, 70);
    CGRect Field1Frame = CGRectMake (10, 10, 290, 70);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:cellRectangle];
    UITextField *textField;
    
    
    //Initialize Label with tag 1.
    
    textField = [[UITextField alloc] initWithFrame:Field1Frame];
    
    textField.tag = 1;
    [cell.contentView addSubview:textField];
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    int x = cell.textLabel.frame.origin.x;
    int y = cell.textLabel.frame.origin.y;
    NSLog(@"%i,%i", x,y);
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(4, 2, 312, cell.frame.size.height-4)];
    textField.backgroundColor = [UIColor blackColor];
    [textField setEnabled:YES];
    [cell addSubview:textField];
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
