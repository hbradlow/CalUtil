//
//  WebcastListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/8/12.
//
//

#import <UIKit/UIKit.h>
#import "Webcast.h"

@interface WebcastListViewController : UITableViewController

@property (nonatomic, copy) NSString *courseID;
@property (nonatomic, retain) NSMutableArray *webcasts;

@end
