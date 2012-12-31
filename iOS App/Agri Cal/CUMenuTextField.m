//
//  CUMenuTextField.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 12/30/12.
//
//

#import "CUMenuTextField.h"

@implementation CUMenuTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor colorWithWhite:0.2 alpha:1] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont fontWithName:kAppFont size:18]];
}

@end
