//
//  NextBusViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 8/30/12.
//
//

#import <UIKit/UIKit.h>
#import "BusStopAnnotation.h"

@interface NextBusViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, weak) BusStopAnnotation *annotation;

@end
