//
//  PanoramaAppDelegate.m
//  Panorama
//
//  Created by Scotty Allen on 8/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PanoramaAppDelegate.h"
#import "PanoramaViewController.h"

@interface PanoramaAppDelegate ()

- (void)setupExternalScreen;

@end

@implementation PanoramaAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize usingExternalScreen;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  [self setupExternalScreen];
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];

  return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

- (void)setupExternalScreen {
  self.usingExternalScreen = NO;
  NSArray *connectedScreens = [UIScreen screens];
  if ([connectedScreens count] > 1) {
    UIScreen *mainScreen = [UIScreen mainScreen];
    for (UIScreen *screen in connectedScreens) {
      BOOL done = NO;
      UIScreenMode *mainScreenMode = [UIScreen mainScreen].currentMode;
      if (screen != mainScreen) {
        for (UIScreenMode *externalScreenMode in screen.availableModes) {
          if (CGSizeEqualToSize(externalScreenMode.size, mainScreenMode.size)) {
            // Select a screen that matches the main screen
            screen.currentMode = externalScreenMode;
            done = YES;
            break;
          }
        }

        if (!done && [screen.availableModes count]) {
          screen.currentMode = [screen.availableModes objectAtIndex:0];
        }

        [window release];
        window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        window.opaque = YES;
        window.hidden = NO;
        window.backgroundColor = [UIColor blackColor];
        //window.layer.contentsGravity = kCAGravityResizeAspect;
        window.screen = screen;
      }
    }
    self.usingExternalScreen = YES;
  }
}

@end
