//
//  Tile.m
//  Tiles
//
//  Created by Kristopher Johnson on 2/3/10.
//  Copyright 2010 Capable Hands Technologies, Inc. All rights reserved.
//

#import "Tile.h"


@implementation Tile

@synthesize tileIndex;


- (NSString *)description {
    return [NSString stringWithFormat:@"<Tile #%d>", (int)tileIndex];
}


- (void)draw {
    
    [[UIColor whiteColor] set];    
    UIFont *font = [UIFont boldSystemFontOfSize:36];
    
    NSString *s = [NSString stringWithFormat:@"%d", (int)tileIndex];
    
    CGSize size = [s sizeWithFont:font];
    CGRect tileBounds = self.bounds;
    
    CGRect textBounds = CGRectMake(tileBounds.origin.x + (tileBounds.size.width - size.width) / 2,
                                   tileBounds.origin.y + (tileBounds.size.height - size.height) / 2,
                                   size.width, size.height);
    [s drawInRect:textBounds withFont:font];    
}


@end
