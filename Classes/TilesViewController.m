//
//  TilesViewController.m
//  Tiles
//

#import "TilesViewController.h"
#import "Tile.h"
#import <QuartzCore/QuartzCore.h>


#define TILE_WIDTH  57
#define TILE_HEIGHT 57
#define TILE_MARGIN 18


@interface TilesViewController ()
- (void)createTiles;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
- (CALayer *)layerForTouch:(UITouch *)touch;
- (int)frameIndexForTileIndex:(int)tileIndex;
- (int)indexOfClosestFrameToPoint:(CGPoint)point;
- (void)moveHeldTileToPoint:(CGPoint)location;
- (void)moveUnheldTilesAwayFromPoint:(CGPoint)location;
- (void)startTilesWiggling;
- (void)stopTilesWiggling;
@end


@implementation TilesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTiles];
}


- (void)createTiles {
    UIColor *tileColors[] = {
        [UIColor blueColor],
        [UIColor brownColor],
        [UIColor grayColor],
        [UIColor greenColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor redColor],
    };
    int tileColorCount = sizeof(tileColors) / sizeof(tileColors[0]);
    
    for (int row = 0; row < TILE_ROWS; ++row) {
        for (int col = 0; col < TILE_COLUMNS; ++col) {
            int index = (row * TILE_COLUMNS) + col;
            
            CGRect frame = CGRectMake(TILE_MARGIN + col * (TILE_MARGIN + TILE_WIDTH),
                                      TILE_MARGIN + row * (TILE_MARGIN + TILE_HEIGHT),
                                      TILE_WIDTH, TILE_HEIGHT);
            tileFrame[index] = frame;
            
            Tile *tile = [[Tile alloc] init];
            tile.tileIndex = index;
            tileForFrame[index] = tile;
            tile.frame = frame;
            tile.backgroundColor = tileColors[index % tileColorCount].CGColor;
            tile.cornerRadius = 8;
            tile.delegate = self;
            [self.view.layer addSublayer:tile];
            [tile setNeedsDisplay];
            [tile release];
        }
    }
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);
    
    Tile *tile = (Tile *)layer;
    [tile draw];
    
    UIGraphicsPopContext();
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CALayer *hitLayer = [self layerForTouch:[touches anyObject]];
    if ([hitLayer isKindOfClass:[Tile class]]) {
        Tile *tile = (Tile*)hitLayer;
        heldTile = tile;
        
        touchStartLocation = [[touches anyObject] locationInView:self.view];
        heldStartPosition = tile.position;
        heldFrameIndex = [self frameIndexForTileIndex:tile.tileIndex];
        
        [tile moveToFront];
        [tile appearDraggable];
        [self startTilesWiggling];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (heldTile) {
        UITouch *touch = [touches anyObject];
        UIView *view = self.view;
        CGPoint location = [touch locationInView:view];
        [self moveHeldTileToPoint:location];
        [self moveUnheldTilesAwayFromPoint:location];
    }
}


- (void)moveHeldTileToPoint:(CGPoint)location {
    float dx = location.x - touchStartLocation.x;
    float dy = location.y - touchStartLocation.y;
    CGPoint newPosition = CGPointMake(heldStartPosition.x + dx, heldStartPosition.y + dy);
    
    [CATransaction begin];
    [CATransaction setDisableActions:TRUE];
    heldTile.position = newPosition;
    [CATransaction commit];
}


- (void)moveUnheldTilesAwayFromPoint:(CGPoint)location {
    int frameIndex = [self indexOfClosestFrameToPoint:location];
    if (frameIndex != heldFrameIndex) {
        [CATransaction begin];
        
        if (frameIndex < heldFrameIndex) {
            for (int i = heldFrameIndex; i > frameIndex; --i) {
                Tile *movingTile = tileForFrame[i-1];
                movingTile.frame = tileFrame[i];
                tileForFrame[i] = movingTile;
            }
        }
        else if (heldFrameIndex < frameIndex) {
            for (int i = heldFrameIndex; i < frameIndex; ++i) {
                Tile *movingTile = tileForFrame[i+1];
                movingTile.frame = tileFrame[i];
                tileForFrame[i] = movingTile;
            }
        }
        heldFrameIndex = frameIndex;
        tileForFrame[heldFrameIndex] = heldTile;
        
        [CATransaction commit];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (heldTile) {
        [heldTile appearNormal];
        heldTile.frame = tileFrame[heldFrameIndex];
        heldTile = nil;
    }
    [self stopTilesWiggling];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


- (CALayer *)layerForTouch:(UITouch *)touch {
    UIView *view = self.view;
    
    CGPoint location = [touch locationInView:view];
    location = [view convertPoint:location toView:nil];
    
    CALayer *hitPresentationLayer = [view.layer.presentationLayer hitTest:location];
    if (hitPresentationLayer) {
        return hitPresentationLayer.modelLayer;
    }
    
    return nil;
}


- (int)frameIndexForTileIndex:(int)tileIndex {
    for (int i = 0; i < TILE_COUNT; ++i) {
        if (tileForFrame[i].tileIndex == tileIndex) {
            return i;
        }
    }
    return 0;
}


- (int)indexOfClosestFrameToPoint:(CGPoint)point {
    int index = 0;
    float minDist = FLT_MAX;
    for (int i = 0; i < TILE_COUNT; ++i) {
        CGRect frame = tileFrame[i];
        
        float dx = point.x - CGRectGetMidX(frame);
        float dy = point.y - CGRectGetMidY(frame);
        
        float dist = (dx * dx) + (dy * dy);
        if (dist < minDist) {
            index = i;
            minDist = dist;
        }
    }
    return index;
}


- (void)startTilesWiggling {
    for (int i = 0; i < TILE_COUNT; ++i) {
        Tile *tile = tileForFrame[i];
        if (tile != heldTile) {
            [tile startWiggling];
        }
    }
}


- (void)stopTilesWiggling {
    for (int i = 0; i < TILE_COUNT; ++i) {
        Tile *tile = tileForFrame[i];
        [tile stopWiggling];
    }
}


@end
