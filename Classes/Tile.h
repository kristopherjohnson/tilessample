//
//  Tile.h
//  Tiles
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CAGradientLayer.h>
#import "CALayer+Additions.h"


@interface Tile : CAGradientLayer {
    int tileIndex;    
}

@property (nonatomic) int tileIndex;

- (void)draw;

- (void)appearDraggable;

- (void)appearNormal;

- (void)startWiggling;

- (void)stopWiggling;

@end
