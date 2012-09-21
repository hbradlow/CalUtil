//
//  InfoViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController <UIAlertViewDelegate,UITableViewDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *detailTitles;
@end
