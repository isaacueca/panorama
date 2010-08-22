//
//  PanoramaViewController.h
//  Panorama
//
//  Created by Scotty Allen on 8/20/10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import "PanoramaAudioManager.h"

@class CylindricalScrollView;

@interface PanoramaViewController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate> {
  CLLocationManager *locationManager;
  UILabel *headingLabel;
  PanoramaAudioManager *audioManager;
  NSArray *scrollViews;
}

@property (nonatomic, retain) PanoramaAudioManager *audioManager;
@end

