//
//  ClassViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/7/12.
//
//

#import "ClassViewController.h"

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Title";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.currentClass.number, self.currentClass.title];
            break;
        case 1:
            cell.textLabel.text = @"Instructor";
            cell.detailTextLabel.text = self.currentClass.instructor;
            break;
        case 2:
            cell.textLabel.text = @"Times";
            cell.detailTextLabel.text = self.currentClass.times;
            break;
        case 3:
            cell.textLabel.text = @"Units";
            cell.detailTextLabel.text = self.currentClass.units;
            break;
        case 4:
            cell.textLabel.text = @"Enrolled";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@",self.currentClass.enrolled, self.currentClass.enrolledLimit];
            break;
        case 5:
            cell.textLabel.text = @"Waitlist";
            cell.detailTextLabel.text = self.currentClass.waitlist;
            break;
        case 6:
            cell.textLabel.text = @"Location";
            cell.detailTextLabel.text = self.currentClass.location;
            break;
        case 7:
            cell.textLabel.text = @"Final";
            cell.detailTextLabel.text = self.currentClass.finalExamGroup;
            break;
        case 8:
            cell.textLabel.text = @"CCN";
            cell.detailTextLabel.text = self.currentClass.ccn;
            break;
        case 9:
            cell.textLabel.text = @"Webcast";
            cell.detailTextLabel.text = self.currentClass.hasWebcast ? @"Yes" : @"No";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    
    return cell;
}

@end
