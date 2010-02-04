//
//  TilesAppDelegate.h
//  Tiles
//
//  Created by Kristopher Johnson on 2/3/10.
//  Copyright Capable Hands Technologies, Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TilesViewController;

@interface TilesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TilesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TilesViewController *viewController;

@end

