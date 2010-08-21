//
//  CylindricalScrollView.h
//  Panorama
//
//  Created by Scotty Allen on 8/21/10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CylindricalScrollView : UIView {
  NSArray *imageNames;
  NSMutableArray *imageViews;
  double viewAngle;
  double pixelsPerDegree;
}

@property(nonatomic, retain) NSArray *imageNames;
@property(nonatomic) double viewAngle;

@end
