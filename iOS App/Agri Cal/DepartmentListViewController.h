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

@property (nonatomic, retain) NSMutableArray *departments;
@property (nonatomic, retain) NSMutableArray *enrolledCourses;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sessionSelector;

@property (nonatomic, retain) DataLoader *classLoader;
@property (nonatomic, retain) DataLoader *departmentLoader;
@property (nonatomic, retain) DataLoader *waitlistLoader;

@end
