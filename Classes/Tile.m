//
//  Tile.m
//  Tiles
//
//  Created by Kristopher Johnson on 2/3/10.
//  Copyright 2010 Capable Hands Technologies, Inc. All rights reserved.
//

#import "Tile.h"
#import "NSString+Additions.h"


@implementation Tile

@synthesize tileIndex;


- (NSString *)description {
    return [NSString stringWithFormat:@"<Tile #%d>", (int)tileIndex];
}


- (void)draw {
    NSString *s = [NSString stringWithFormat:@"%d", (int)tileIndex];

    [[UIColor whiteColor] set];    
    UIFont *font = [UIFont boldSystemFontOfSize:36];
    [s drawCenteredInRect:self.bounds withFont:font];
    
    [self drawGlossGradient];
}


- (void)appearDraggable {    
    self.opacity = 0.6;
    [self setValue:[NSNumber numberWithFloat:1.25] forKeyPath:@"transform.scale"];
}


- (void)appearNormal {
    self.opacity = 1.0;
    [self setValue:[NSNumber numberWithFloat:1.0] forKeyPath:@"transform.scale"];
}


@end
