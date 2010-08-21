//
//  CylindricalScrollView.h
//  Panorama
//
//  Created by Scotty Allen on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CylindricalScrollView : UIView {
  NSArray *imageNames;
}

- (void)rotateTo:(double)angle;

@property(nonatomic, retain) NSArray *imageNames;

@end
