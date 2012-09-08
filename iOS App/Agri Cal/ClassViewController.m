//
//  ClassViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/7/12.
//
//

#import "ClassViewController.h"
#import "WebcastListViewController.h"

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            cell.accessoryType = self.currentClass.hasWebcast ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            cell.selectionStyle = self.currentClass.hasWebcast ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 9 && self.currentClass.hasWebcast)
    {
        [self performSegueWithIdentifier:@"webcast" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebcastListViewController *controller = [segue destinationViewController];
    controller.courseID = [self.currentClass uniqueID];
    controller.navigationItem.title = self.currentClass.title;
}

@end
