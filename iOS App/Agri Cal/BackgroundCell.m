//
//  BackgroundCell.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 9/10/12.
//
//

#import "BackgroundCell.h"

@implementation BackgroundCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
