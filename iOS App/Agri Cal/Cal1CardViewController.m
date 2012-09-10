//
//  Cal1CardViewController.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/6/12.
//
//

#import "Cal1CardViewController.h"

@interface Cal1CardViewController ()

@end

@implementation Cal1CardViewController
@synthesize imageView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    @try {
        UIImage * img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ServerURL, self.annotation.imageURL]]]];
        self.imageView.image = img;
    }
    @catch (NSException *exception) {
        NSLog(@"Error when loading image");
    }
    self.navigationController.title = self.annotation.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section)
        return @"Description";
    else
        return @"Hours of operation";
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 100;
    if (indexPath.section)
    {
        cell.textLabel.text = self.annotation.info;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
        cell.textLabel.text = self.annotation.times;
    }
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize detailSize;
    float returnValue = 0;
    switch (indexPath.section) {
        case 0:
            detailSize = [self.annotation.times sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(270, 4000)lineBreakMode:UILineBreakModeWordWrap];
            returnValue = detailSize.height + 4;
            break;
        case 1:
            detailSize = [self.annotation.info sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(270, 4000)lineBreakMode:UILineBreakModeWordWrap];
            returnValue = detailSize.height + 4;
            break;
    }
    if (returnValue == 4 || !returnValue)
        return 0;
    else
        return returnValue;
}
- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
