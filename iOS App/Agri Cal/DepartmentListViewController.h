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
@property (nonatomic, strong) NSMutableArray *enrolledCoursesSp;
@property (nonatomic, strong) NSMutableArray *waitlistedCoursesSp;
@property (nonatomic, strong) NSMutableArray *enrolledCoursesFa;
@property (nonatomic, strong) NSMutableArray *waitlistedCoursesFa;
@property (nonatomic, strong) NSMutableArray *enrolledCoursesSu;
@property (nonatomic, strong) NSMutableArray *waitlistedCoursesSu;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sessionSelector;

@property (nonatomic, strong) DataLoader *departmentLoader;
@property (nonatomic, strong) DataLoader *classLoaderFa;
@property (nonatomic, strong) DataLoader *waitlistLoaderFa;
@property (nonatomic, strong) DataLoader *waitlistLoaderSp;
@property (nonatomic, strong) DataLoader *classLoaderSp;
@property (nonatomic, strong) DataLoader *waitlistLoaderSu;
@property (nonatomic, strong) DataLoader *classLoaderSu;

- (IBAction)switchSession:(id)sender;
@end
