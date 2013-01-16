//
//  NewsListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/10/12.
//
//

#import <UIKit/UIKit.h>
#import "FrontTableViewController.h"
#import "DataLoader.h"

@interface NewsListViewController : FrontTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *rssFeed; 
@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) UITableView *menuTableView;
@property (nonatomic, retain) DataLoader *dataLoader;
@property BOOL hasLoaded;
@property BOOL isMenuHidden;
@end
