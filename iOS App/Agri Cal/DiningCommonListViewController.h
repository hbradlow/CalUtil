//
//  DiningCommonListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import <UIKit/UIKit.h>
#import "FrontTableViewController.h"
#import "DataLoader.h"

@interface DiningCommonListViewController : FrontTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *locationSelector;
@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (retain, nonatomic) NSMutableArray *locations;
@property (retain, nonatomic) DataLoader *menuLoader;

@end