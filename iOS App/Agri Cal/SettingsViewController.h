#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#import "RevealController.h"
#import "DiningCommonListViewController.h"
#import "DepartmentListViewController.h"
#import "NewsListViewController.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
