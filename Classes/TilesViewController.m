//
//  TilesViewController.m
//  Tiles
//
//  Created by Kristopher Johnson on 2/3/10.
//  Copyright Capable Hands Technologies, Inc. 2010. All rights reserved.
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
- (Tile *)tileForFrameIndex:(int)frameIndex;
- (int)frameIndexForTileIndex:(int)tileIndex;
- (int)indexOfClosestFrameToPoint:(CGPoint)point;
- (void)moveHeldTileToPoint:(CGPoint)location;
- (void)moveUnheldTilesAwayFromPoint:(CGPoint)location;
@end


@implementation TilesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTiles];
}


- (void)createTiles {
    UIColor *colors[] = {
        [UIColor blueColor],
        [UIColor brownColor],
        [UIColor grayColor],
        [UIColor greenColor],
        [UIColor orangeColor],
        [UIColor purpleColor],
        [UIColor redColor],
    };
    int colorCount = sizeof(colors) / sizeof(colors[0]);
    
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
            tile.backgroundColor = colors[index % colorCount].CGColor;
            tile.cornerRadius = 8;
            tile.masksToBounds = YES;
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
        heldTileStartPosition = tile.position;
        heldTileFrameIndex = [self frameIndexForTileIndex:tile.tileIndex];
        
        [tile moveToFront];
        [tile appearDraggable];
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
    CGPoint newPosition = CGPointMake(heldTileStartPosition.x + dx, heldTileStartPosition.y + dy);
    
    [CATransaction begin];
    [CATransaction setDisableActions:TRUE];
    heldTile.position = newPosition;
    [CATransaction commit];
    
}


- (void)moveUnheldTilesAwayFromPoint:(CGPoint)location {
    int frameIndex = [self indexOfClosestFrameToPoint:location];
    if (frameIndex != heldTileFrameIndex) {
        Tile *movingTile = tileForFrame[frameIndex];
        movingTile.frame = tileFrame[heldTileFrameIndex];
        tileForFrame[heldTileFrameIndex] = movingTile;
        
        heldTileFrameIndex = frameIndex;
        tileForFrame[heldTileFrameIndex] = heldTile;
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (heldTile) {
        [heldTile appearNormal];
        heldTile.frame = tileFrame[heldTileFrameIndex];
        heldTile = nil;
    }
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


- (Tile *)tileForFrameIndex:(int)frameIndex {
    return tileForFrame[frameIndex];
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
        float frameCenterX = frame.origin.x + frame.size.width / 2;
        float frameCenterY = frame.origin.y + frame.size.height / 2;
        
        float dx = point.x - frameCenterX;
        float dy = point.y - frameCenterY;
        
        float dist = (dx * dx) + (dy * dy);
        if (dist < minDist) {
            index = i;
            minDist = dist;
        }
    }
    return index;
}


@end
