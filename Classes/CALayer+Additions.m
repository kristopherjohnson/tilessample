//
//  CALayer+Additions.m
//  Tiles
//

#import "CALayer+Additions.h"


@implementation CALayer (Additions)


- (void)moveToFront {
    CALayer *superlayer = self.superlayer;
    [self removeFromSuperlayer];
    [superlayer addSublayer:self];
}


@end
