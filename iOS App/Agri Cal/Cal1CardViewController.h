//
//  Cal1CardViewController.h
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import <UIKit/UIKit.h>
#import "Cal1CardAnnotation.h"

@interface Cal1CardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) Cal1CardAnnotation *annotation;
@property (nonatomic, copy) NSString *type;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
