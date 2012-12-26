//
//  NewsListViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/10/12.
//
//

#import <UIKit/UIKit.h>

@interface NewsListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *rssFeed; 
@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) UITableView *menuTableView;
@property BOOL hasLoaded;
@property BOOL isMenuHidden;

- (IBAction)showMenu:(id)sender;
@end