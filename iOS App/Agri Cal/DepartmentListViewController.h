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

@property (nonatomic, strong) NSMutableArray *departments;
@property (nonatomic, strong) NSMutableArray *enrolledCourses;
@property (nonatomic, strong) NSMutableArray *waitlistedCourses;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sessionSelector;

@property (nonatomic, strong) DataLoader *classLoader;
@property (nonatomic, strong) DataLoader *departmentLoader;
@property (nonatomic, strong) DataLoader *waitlistLoader;

@end
