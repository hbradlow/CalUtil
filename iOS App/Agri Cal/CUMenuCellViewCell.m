//
//  CUMenuCellViewCell.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 12/26/12.
//
//

#import "CUMenuCellViewCell.h"

@implementation CUMenuCellViewCell

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *whiteColor = [UIColor colorWithWhite:0.12 alpha:1];
    UIColor *lightGrayColor = [UIColor colorWithWhite:0.12 alpha:1];
    
    CGRect paperRect = self.bounds;
    
    drawCellGradient(context, paperRect, whiteColor, lightGrayColor);
    
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
void drawCellGradient(CGContextRef context, CGRect rect, UIColor* startColor,
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
