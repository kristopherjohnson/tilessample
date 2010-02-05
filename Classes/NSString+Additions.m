//
//  NSString+Additions.m
//  Tiles
//
//  Created by Kristopher Johnson on 2/4/10.
//  Copyright 2010 Capable Hands Technologies, Inc.. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (Additions)


- (void)drawCenteredInRect:(CGRect)rect withFont:(UIFont *)font {
    CGSize size = [self sizeWithFont:font];
    
    CGRect textBounds = CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
                                   rect.origin.y + (rect.size.height - size.height) / 2,
                                   size.width, size.height);
    [self drawInRect:textBounds withFont:font];    
}


@end
