//
//  CUSettingsHeader.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 12/30/12.
//
//

#import "CUSettingsHeader.h"

@implementation CUSettingsHeader

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
    UIColor* separatorColor = [UIColor colorWithWhite:0 alpha:1];
    
    CGContextSetFillColorWithColor(context, [separatorColor CGColor]);
    CGContextFillRect(context, separator);
    
    separator.origin.y -= self.bounds.size.height-1;
    
    separatorColor = [UIColor colorWithWhite:0.9 alpha:0.05];
    
    CGContextSetFillColorWithColor(context, [separatorColor CGColor]);
    CGContextFillRect(context, separator);
}


@end
