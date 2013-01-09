//
//  CUTableHeaderView.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/8/13.
//
//

#import "CUTableHeaderView.h"

@implementation CUTableHeaderView

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);
    CGContextFillRect(context, self.bounds);
    
    CGRect separator = CGRectMake(self.bounds.origin.x,
                                  self.bounds.origin.y+self.bounds.size.height-1,
                                  self.bounds.size.width,
                                  1.0f);
    UIColor* separatorColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    CGContextSetFillColorWithColor(context, [separatorColor CGColor]);
    CGContextFillRect(context, separator);
    
    separator.origin.y -= self.bounds.size.height-1;
    
    separatorColor = [UIColor colorWithWhite:0.98 alpha:0.05];
    
    CGContextSetFillColorWithColor(context, [separatorColor CGColor]);
    CGContextFillRect(context, separator);
}


@end
