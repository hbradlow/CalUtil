//
//  DepartmentListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import <UIKit/UIKit.h>
#import "Department.h"

@interface DepartmentListViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *departments;
@property (nonatomic, retain) NSMutableArray *enrolledCourses;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sessionSelector;

@end
