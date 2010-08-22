//
//  PanoramaAppDelegate.h
//  Panorama
//
//  Created by Scotty Allen on 8/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PanoramaViewController;

@interface PanoramaAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  PanoramaViewController *viewController;
  BOOL usingExternalScreen;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PanoramaViewController *viewController;
@property (nonatomic) BOOL usingExternalScreen;

@end

