//
//  CUSegmentedControl.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/16/13.
//
//

#import "CUSegmentedControl.h"

@implementation CUSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 1.0f;
}


@end
