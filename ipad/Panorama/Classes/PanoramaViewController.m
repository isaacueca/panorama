//
//  PanoramaViewController.m
//  Panorama
//
//  Created by Scotty Allen on 8/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PanoramaViewController.h"
#import "CylindricalScrollView.h"
#import "PanoramaAppDelegate.h"

double FRAME_RATE = 40.0;
double EASING = 7.0;

@interface PanoramaViewController ()

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) UILabel *headingLabel;
@property(nonatomic, retain) NSArray *scrollViews;
@property(nonatomic, retain) NSTimer *updateTimer;
@property(nonatomic) double currentHeading;
@property(nonatomic) double lastReportedHeading;

- (void)startListening;
- (void)updateImageViews:(NSTimer *)timer;

@end

@implementation PanoramaViewController

@synthesize locationManager;
@synthesize headingLabel;
@synthesize audioManager;
@synthesize scrollViews;
@synthesize updateTimer;
@synthesize currentHeading;
@synthesize lastReportedHeading;

- (void)dealloc {
  self.locationManager = nil;
  self.headingLabel = nil;
  self.audioManager = nil;
  self.scrollViews = nil;
  self.updateTimer = nil;
  [super dealloc];
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];

  self.currentHeading = 0;
  self.lastReportedHeading = 0;

  self.audioManager = [[ PanoramaAudioManager alloc ] init ];
  [ self.audioManager loadTestSounds ];
  [ self.audioManager startSounds ];

  CylindricalScrollView *scrollView = [[[CylindricalScrollView alloc]
                                        initWithFrame:CGRectMake(0, 0, 1024, 768)] autorelease];
  scrollView.imageNames = [NSArray arrayWithObjects:@"AA_01.png", @"AA_02.png", @"AA_03.png",
                           @"AA_04.png", @"AA_05.png", @"AA_06.png", @"AA_07.png", @"AA_08.png",
                           @"AA_09.png", @"AA_10.png", @"AA_11.png", @"AA_12.png", @"AA_13.png",
                           nil];

  scrollView.opaque = NO;
  [self.view addSubview:scrollView];
  
  CylindricalScrollView *scrollView2 = [[[CylindricalScrollView alloc]
                                         initWithFrame:CGRectMake(0, 0, 1024, 768)] autorelease];
  scrollView2.imageNames = [NSArray arrayWithObjects:@"B_01.png", @"B_02.png", @"B_03.png",
                            @"B_04.png", @"B_05.png", @"B_06.png", @"B_07.png", @"B_08.png",
                            @"B_09.png", @"B_10.png", @"B_11.png", @"B_12.png", @"B_13.png",
                            @"B_14.png", @"B_15.png", nil];

  scrollView2.opaque = NO;
  [self.view addSubview:scrollView2];
  
  self.scrollViews = [NSArray arrayWithObjects:scrollView, scrollView2, nil];
  
  self.headingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(400, 0, 200, 30)] autorelease];
  self.headingLabel.text = @"Heading:";
  [self.view addSubview:self.headingLabel];

  updateTimer = [[NSTimer scheduledTimerWithTimeInterval:1/FRAME_RATE
                                                  target:self
                                                selector:@selector(updateImageViews:)
                                                userInfo:nil
                                                 repeats:YES] retain];

  [self startListening];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  PanoramaAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  if (appDelegate.usingExternalScreen) {
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
  } else {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
  }
}

- (void)didReceiveMemoryWarning {
  // TODO(scotty): implement this
  [super didReceiveMemoryWarning];
}

- (void)startListening {
	// Start taking heading readings.

	if (!self.locationManager) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];

		// we want every move.
		self.locationManager.headingFilter = kCLHeadingFilterNone;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

		[self.locationManager startUpdatingHeading];
    self.locationManager.delegate = self;
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  self.lastReportedHeading = [newHeading magneticHeading];
  [ self.audioManager updateHeading:self.lastReportedHeading];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
  return YES;
}

- (double)circularDifferenceBetween:(double)firstVal and:(double)secondVal withMax:(double)max {
  double result = fmod(secondVal - firstVal, max);
  if (result > max / 2.0) {
    result -= max;
  }
  if (result < max / -2.0) {
    result += 360;
  }
  return result;
}

- (double)circularAdd:(double)firstVal and:(double)secondVal withMax:(double)max {
  double result = fmod(firstVal + secondVal, 360.0);
  if (result < 0) {
    result += max;
  }
  return result;
}

- (void)updateImageViews:(NSTimer *)timer {
  double difference = [self circularDifferenceBetween:self.currentHeading
                                                  and:self.lastReportedHeading
                                              withMax:360.0];
  
  self.currentHeading = [self circularAdd:self.currentHeading
                                      and:difference / EASING
                                  withMax:360.0];
  self.headingLabel.text = [NSString stringWithFormat:@"Heading: %f", self.currentHeading];
  for (CylindricalScrollView *scrollView in self.scrollViews) {
    scrollView.viewAngle = self.currentHeading;
  }
}

@end
