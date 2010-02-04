//
//  TilesAppDelegate.m
//  Tiles
//
//  Created by Kristopher Johnson on 2/3/10.
//  Copyright Capable Hands Technologies, Inc. 2010. All rights reserved.
//

#import "TilesAppDelegate.h"
#import "TilesViewController.h"

@implementation TilesAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
