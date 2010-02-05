//
//  Tile.h
//  Tiles
//
//  Created by Kristopher Johnson on 2/3/10.
//  Copyright 2010 Capable Hands Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CALayer+Additions.h"


@interface Tile : CALayer {
    int tileIndex;    
}

@property (nonatomic) int tileIndex;

- (void)draw;

- (void)appearDraggable;

- (void)appearNormal;

@end
