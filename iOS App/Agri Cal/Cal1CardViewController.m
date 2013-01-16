//
//  Cal1CardViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import "Cal1CardViewController.h"
#import "CalCardCell.h"
#import "CUTableHeaderView.h"

@interface Cal1CardViewController ()

@end

@implementation Cal1CardViewController
@synthesize imageView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    @try {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{
            UIImage * img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.annotation.imageURL]]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.imageView.image = img;
            });
        });
    }
    @catch (NSException *exception) {
        NSLog(@"Error when loading image");
    }
    self.navigationController.title = self.annotation.title;
    NSLog(@"%@%@", self.annotation.times, self.annotation.info);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self.annotation.times count])
    {
        return 44;
    }
    else
    {
        CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width, 10000);
        CGSize expectedLabelSize = [self.annotation.info sizeWithFont:[UIFont systemFontOfSize:22]
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:UILineBreakModeWordWrap];
        return expectedLabelSize.height;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.annotation.times count] + 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]);
    CUTableHeaderView *view = [[CUTableHeaderView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    rect.origin.y += 1;
    rect.size.height -= 2;
    rect.size.width -= 4;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = kAppBlueColor;
    label.backgroundColor = [UIColor clearColor];
    int max = [self.annotation.times count];
    if (section < max)
    {
        label.text = [[self.annotation.times objectAtIndex:section] objectForKey:@"span"];
        if ([label.text isEqualToString:@""])
            label.text = @"Built in";
    }
    else
    {
        label.text = @"Info";
    }
    
    [view addSubview:label];
    return view;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[CalCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    NSString *timeString;
    switch (indexPath.section) {
        case 0:
            timeString = [[self.annotation.times objectAtIndex:indexPath.row] objectForKey:@"span"];
            if ([timeString isEqualToString:@""])
                cell.textLabel.text = @"N/A";
            else
                cell.textLabel.text = timeString;
            break;
        case 1:
            cell.textLabel.text = self.annotation.info;
            break;
        case 2:
            break;
        default:
            break;
    }
    return cell;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
