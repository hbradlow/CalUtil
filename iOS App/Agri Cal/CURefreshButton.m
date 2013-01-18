//
//  CURefreshButton.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/17/13.
//
//

#import "CURefreshButton.h"

@implementation CURefreshButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CGRect innerFrame = CGRectInset(frame, 8.0f, 8.0f);
        self.activityIndicator = [[UIActivityIndicatorView alloc]
                             initWithFrame:innerFrame];
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:self.activityIndicator];
    }
    return self;
}

- (void) startAnimating
{
    [self.activityIndicator startAnimating];
}

- (void) stopAnimating
{
    [self.activityIndicator stopAnimating];
}

@end
