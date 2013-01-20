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
#import <QuartzCore/QuartzCore.h>

@interface Cal1CardViewController ()

@end

@implementation Cal1CardViewController
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.imageView.layer.shadowRadius = 2.0f;
    self.imageView.layer.shadowOpacity = 1.0f;
}

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
    self.titleLabel.text = self.annotation.title;
    NSString *timeString = [[self.annotation.times objectAtIndex:0] objectForKey:@"span"];
    if ([timeString isEqualToString:@""] || (NSNull*)timeString == [NSNull null])
        timeString = @"N/A";
    timeString = [timeString stringByReplacingOccurrencesOfString:@"Built " withString:@""];
    if ([self.type isEqualToString:kBuildingType])
        self.timeLabel.text = [NSString stringWithFormat:@"Built in: %@", timeString];
    else 
        self.timeLabel.text = [NSString stringWithFormat:@"Hours: %@", timeString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width-10, 10000);
    CGSize expectedLabelSize = [self.annotation.info sizeWithFont:[UIFont fontWithName:kAppFont size:19]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:UILineBreakModeWordWrap];
    return expectedLabelSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[CalCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    NSLog(@"%@", self.annotation.info);
    cell.textLabel.text = [self.annotation.info stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    cell.textLabel.font = [UIFont fontWithName:kAppFont size:18];
    CGRect frame = cell.textLabel.frame;
    frame.origin.y += 4;
    cell.textLabel.frame = frame;
    cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    return cell;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setTableView:nil];
    [self setTitleLabel:nil];
    [self setTimeLabel:nil];
    [super viewDidUnload];
}
@end
