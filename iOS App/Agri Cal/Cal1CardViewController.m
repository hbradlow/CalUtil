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
    if ([timeString isEqualToString:@""])
        timeString = @"N/A";
    
    if ([self.type isEqualToString:kBuildingType])
        self.timeLabel.text = [NSString stringWithFormat:@"Built in %@", timeString];
    else if ([self.type isEqualToString:kLibType])
        self.timeLabel.text = [NSString stringWithFormat:@"Open %@", timeString];
    else
        self.timeLabel.text = [NSString stringWithFormat:@"Open %@",[[self.annotation.times objectAtIndex:0] objectForKey:@"days"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width, 10000);
    CGSize expectedLabelSize = [self.annotation.info sizeWithFont:[UIFont systemFontOfSize:22]
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
    CUTableHeaderView *view = [[CUTableHeaderView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    rect.origin.x += 10;
    rect.origin.y += 1;
    rect.size.height -= 2;
    rect.size.width -= 4;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = kAppBlueColor;
    label.backgroundColor = [UIColor clearColor];
    
    [view addSubview:label];
    return view;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[CalCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.text = [self.annotation.info stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
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
