//
//  ClassViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/7/12.
//
//

#import <UIKit/UIKit.h>
#import "CalClass.h"
#import "DataLoader.h"

@interface ClassViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) CalClass *currentClass;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) DataLoader *classLoader;

@end
