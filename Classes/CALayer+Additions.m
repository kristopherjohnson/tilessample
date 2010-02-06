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


@end
