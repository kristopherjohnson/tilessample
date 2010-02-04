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
@end


@implementation TilesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTiles];
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)createTiles {
    int row, col;
    for (row = 0; row < TILE_ROWS; ++row) {
        for (col = 0; col < TILE_COLUMNS; ++col) {
            int index = (row * TILE_COLUMNS) + col;
            
            tileFrame[index] = CGRectMake(TILE_MARGIN + col * (TILE_MARGIN + TILE_WIDTH),
                                          TILE_MARGIN + row * (TILE_MARGIN + TILE_HEIGHT),
                                          TILE_WIDTH, TILE_HEIGHT);
            
            Tile *tile = [[Tile alloc] init];
            tile.tileIndex = index;
            tile.frame = tileFrame[index];
            tile.backgroundColor = [UIColor blueColor].CGColor;
            tile.delegate = self;
            tile.cornerRadius = 8;
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
        
        [tile moveToFront];
        [tile appearDraggable];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (heldTile) {
        UITouch *touch = [touches anyObject];
        UIView *view = self.view;
        
        CGPoint location = [touch locationInView:view];
        
        float dx = location.x - touchStartLocation.x;
        float dy = location.y - touchStartLocation.y;
        CGPoint newPosition = CGPointMake(heldTileStartPosition.x + dx, heldTileStartPosition.y + dy);
        
        [CATransaction begin];
        [CATransaction setDisableActions:TRUE];
        heldTile.position = newPosition;
        [CATransaction commit];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (heldTile) {
        [heldTile appearNormal];
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


@end
