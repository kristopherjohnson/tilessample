//
//  CALayer+Additions.m
//  Tiles
//
//  Created by Kristopher Johnson on 2/4/10.
//  Copyright 2010 Capable Hands Technologies, Inc.. All rights reserved.
//

#import "CALayer+Additions.h"


@implementation CALayer (Additions)


- (void)moveToFront {
    CALayer *superlayer = self.superlayer;
    [self removeFromSuperlayer];
    [superlayer addSublayer:self];
}


// Based on code provided by Brad Larson at
// http://stackoverflow.com/questions/422066/gradients-on-uiview-and-uilabels-on-iphone/422208#422208
// 
- (void)drawGlossGradient {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 0.35,
        1.0, 1.0, 1.0, 0.06
    };
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRef glossGradient = CGGradientCreateWithColorComponents(rgbColorspace,
                                                                        components,
                                                                        locations,
                                                                        num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
}


@end
