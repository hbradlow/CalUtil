//
//  ClassListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/7/12.
//
//

#import <UIKit/UIKit.h>

@interface ClassListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *classes;
@property (nonatomic, retain) NSString *departmentURL;
@property (nonatomic, retain) NSMutableArray *searchResults;

@end
