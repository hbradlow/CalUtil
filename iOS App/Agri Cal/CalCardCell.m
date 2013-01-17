//
//  CalCardCell.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 1/11/13.
//
//

#import "CalCardCell.h"

@implementation CalCardCell
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *whiteColor = [UIColor colorWithWhite:0.98 alpha:1];
    UIColor *lightGrayColor = [UIColor colorWithWhite:0.97 alpha:1];
    
    CGRect paperRect = CGRectInset(self.bounds, 4, 4);
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.9 alpha:1] CGColor]);
    CGContextFillRect(context, paperRect);
    
    paperRect = CGRectInset(paperRect, 1, 1);
    
    drawCalCellGradient(context, paperRect, whiteColor, lightGrayColor);
}

void drawCalCellGradient(CGContextRef context, CGRect rect, UIColor* startColor,
                        UIColor*  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

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
