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
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithHue:0 saturation:0 brightness:0.98 alpha:1] CGColor]);
    CGContextFillRect(context, self.bounds);
    
    CGRect separator = CGRectMake(self.bounds.origin.x,
                                  self.bounds.origin.y+self.bounds.size.height-1,
                                  self.bounds.size.width,
                                  1.0f);
    UIColor* separatorColor = kAppBlueColor;
    
    CGContextSetFillColorWithColor(context, [separatorColor CGColor]);
    CGContextFillRect(context, separator);
    
    separator.origin.y -= self.bounds.size.height-1;
    
    CGContextSetFillColorWithColor(context, [separatorColor CGColor]);
    CGContextFillRect(context, separator);
}


@end
