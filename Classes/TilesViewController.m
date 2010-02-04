//
//  TilesViewController.m
//  Tiles
//
//  Created by Kristopher Johnson on 2/3/10.
//  Copyright Capable Hands Technologies, Inc. 2010. All rights reserved.
//

#import "TilesViewController.h"
#import "Tile.h"

#define TILE_WIDTH  57
#define TILE_HEIGHT 57
#define TILE_MARGIN 18

@interface TilesViewController ()
- (void)createLayers;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
@end


@implementation TilesViewController


- (void)awakeFromNib {
    [super awakeFromNib];
    [self createLayers];
}

- (void)createLayers {
    int row, col;
    for (row = 0; row < 6; ++row) {
        for (col = 0; col < 4; ++col) {
            Tile *tile = [[Tile alloc] init];
            tile.tileIndex = (row * 4) + col;
            tile.frame = CGRectMake(TILE_MARGIN + col * (TILE_MARGIN + TILE_WIDTH),
                                     TILE_MARGIN + row * (TILE_MARGIN + TILE_HEIGHT),
                                     TILE_WIDTH, TILE_HEIGHT);
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

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
