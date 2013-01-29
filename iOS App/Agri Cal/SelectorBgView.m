//
//  SelectorBgView.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/29/13.
//
//

#import "SelectorBgView.h"

@implementation SelectorBgView

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
    UIImage *background = [UIImage imageNamed:@"specklebg"];
    
    UIColor *color = [UIColor colorWithPatternImage:background ] ;
    [color set];
    
    UIRectFill([self bounds]) ;
}

@end
