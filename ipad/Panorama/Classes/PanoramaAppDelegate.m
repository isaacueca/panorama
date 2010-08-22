//
//  PanoramaAppDelegate.m
//  Panorama
//
//  Created by Scotty Allen on 8/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PanoramaAppDelegate.h"
#import "PanoramaViewController.h"
#import "UIApplication+ScreenMirroring.h"

@implementation PanoramaAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];
  [[UIApplication sharedApplication] setupScreenMirroring];

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

@end
