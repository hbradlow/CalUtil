#import <UIKit/UIKit.h>
#import "InfoViewController.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@end
