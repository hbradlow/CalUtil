//
//  CUNavigationItem.m
//  Agri Cal
//
//  Created by Kevin Lindkvist on 12/26/12.
//
//

#import "CUNavigationItem.h"

@implementation CUNavigationItem
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *whiteColor = [UIColor colorWithWhite:0.15 alpha:1];
    UIColor *lightGrayColor = [UIColor colorWithWhite:0.12 alpha:1];
    
    CGRect paperRect = self.bounds;
    drawLinearGradient(context, paperRect, whiteColor, lightGrayColor);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 1.0f;
}
void drawLinearGradient(CGContextRef context, CGRect rect, UIColor* startColor,
                        UIColor*  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (__bridge CFArrayRef) colors, locations);
    
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

@end
