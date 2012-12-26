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
    
    CGColorRef whiteColor = [UIColor colorWithWhite:0.2 alpha:1].CGColor;
    CGColorRef lightGrayColor = [UIColor colorWithWhite:0.1 alpha:1].CGColor;
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, whiteColor, lightGrayColor);
}
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor,
                        CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
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
