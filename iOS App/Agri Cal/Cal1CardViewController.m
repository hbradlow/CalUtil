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
    UIImage * img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ServerURL, self.annotation.imageURL]]]];
    self.imageView.image = img;
    self.navigationController.title = self.annotation.title;
    NSLog(@"%@ %@", self.annotation.info, self.annotation.times);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.annotation.type;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 100;
    if (indexPath.row)
    {
        cell.textLabel.text = self.annotation.info;
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:16];
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12];
        cell.textLabel.text = self.annotation.times;
    }
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize detailSize;
    switch (indexPath.row) {
        case 0:
            detailSize = [self.annotation.times sizeWithFont:[UIFont systemFontOfSize:12]constrainedToSize:CGSizeMake(270, 4000)lineBreakMode:UILineBreakModeWordWrap];
            return detailSize.height + 4;
            break;
        case 1:
            detailSize = [self.annotation.info sizeWithFont:[UIFont systemFontOfSize:16]constrainedToSize:CGSizeMake(270, 4000)lineBreakMode:UILineBreakModeWordWrap];
            return detailSize.height + 4;
            break;
        default:
            return 0;
            break;
    }
}
- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
