//
//  DepartmentListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import <UIKit/UIKit.h>
#import "Department.h"
#import "FrontTableViewController.h"
#import "DataLoader.h"

@interface DepartmentListViewController : FrontTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong) NSMutableArray *departments;
@property (strong) NSMutableArray *enrolledCoursesSp;
@property (strong) NSMutableArray *waitlistedCoursesSp;
@property (strong) NSMutableArray *enrolledCoursesFa;
@property (strong) NSMutableArray *waitlistedCoursesFa;
@property (strong) NSMutableArray *enrolledCoursesSu;
@property (strong) NSMutableArray *waitlistedCoursesSu;
@property (strong) NSMutableArray *sessions;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sessionSelector;

@property (nonatomic, strong) DataLoader *departmentLoader;
@property (nonatomic, strong) DataLoader *classLoaderFa;
@property (nonatomic, strong) DataLoader *waitlistLoaderFa;
@property (nonatomic, strong) DataLoader *waitlistLoaderSp;
@property (nonatomic, strong) DataLoader *classLoaderSp;
@property (nonatomic, strong) DataLoader *waitlistLoaderSu;
@property (nonatomic, strong) DataLoader *classLoaderSu;
@property (nonatomic, strong) DataLoader *sessionLoader;

- (IBAction)switchSession:(id)sender;
@end
