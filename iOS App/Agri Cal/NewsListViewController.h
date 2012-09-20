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
@property BOOL hasLoaded;
@end
