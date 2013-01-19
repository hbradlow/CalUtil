//
//  ClassListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/7/12.
//
//

#import <UIKit/UIKit.h>
#import "DataLoader.h"

@interface ClassListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *classes;
@property (nonatomic, copy) NSString *departmentURL;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) DataLoader *courseLoader;
@property (nonatomic, copy) NSString *departmentSeason;

@end
