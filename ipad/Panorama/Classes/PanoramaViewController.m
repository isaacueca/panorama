//
//  PanoramaViewController.m
//  Panorama
//
//  Created by Scotty Allen on 8/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PanoramaViewController.h"
#import "CylindricalScrollView.h"

@interface PanoramaViewController ()

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) UILabel *headingLabel;

- (void)startListening;

@end

@implementation PanoramaViewController

@synthesize locationManager;
@synthesize headingLabel;
@synthesize audioManager;

- (void)dealloc {
  self.locationManager = nil;
  self.headingLabel = nil;
  self.audioManager = nil;
  [super dealloc];
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  self.audioManager = [[ PanoramaAudioManager alloc ] init ];
  CylindricalScrollView *scrollView = [[CylindricalScrollView alloc]
                                       initWithFrame:CGRectMake(0, 0, 1024, 768)];
  self.headingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(400, 0, 200, 30)] autorelease];
  self.headingLabel.text = @"Heading:";
  [self.view addSubview:scrollView];
  [self.view addSubview:self.headingLabel];
  [self startListening];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
  // TODO(scotty): implement this
  [super didReceiveMemoryWarning];
}

- (void)startListening {
	// Start taking heading readings.

	if (!self.locationManager) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];

		//we want every move.
		self.locationManager.headingFilter = kCLHeadingFilterNone;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

		[self.locationManager startUpdatingHeading];
    self.locationManager.delegate = self;
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
  NSLog(@"New heading: %f", [newHeading magneticHeading]);
  self.headingLabel.text = [NSString stringWithFormat:@"Heading: %f", [newHeading magneticHeading]];
}

@end
