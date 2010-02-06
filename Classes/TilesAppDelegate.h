//
//  TilesAppDelegate.h
//  Tiles
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

