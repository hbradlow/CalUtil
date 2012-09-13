#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize username;
@synthesize password;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.username.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    self.password.text = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    [self.loginLabel setFont:[UIFont fontWithName:@"UCBerkeleyOS" size:40]];
    [self.saveButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:0 green:63.0/255 blue:135.0/255 alpha:1],UITextAttributeTextColor,[UIColor whiteColor],UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset , [UIFont fontWithName:@"UCBerkeleyOS" size:20.0],UITextAttributeFont, nil] forState:UIControlStateNormal];
}
- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [self setLoginLabel:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"save"])
        [[NSUserDefaults standardUserDefaults] setValue:self.username.text forKey:kUserName];
        [[NSUserDefaults standardUserDefaults] setValue:password.text forKey:kPassword];
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
@end
