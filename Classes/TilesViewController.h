//
//  TilesViewController.h
//  Tiles
//
//  Created by Kristopher Johnson on 2/3/10.
//  Copyright Capable Hands Technologies, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TILE_ROWS    6
#define TILE_COLUMNS 4
#define TILE_COUNT   (TILE_ROWS * TILE_COLUMNS)

@class Tile;

@interface TilesViewController : UIViewController {
@private
    CGRect   tileFrame[TILE_COUNT];
    Tile    *tileForFrame[TILE_COUNT];
    Tile    *heldTile;
    int      heldTileFrameIndex;
    CGPoint  heldTileStartPosition;
    CGPoint  touchStartLocation;
}

@end

