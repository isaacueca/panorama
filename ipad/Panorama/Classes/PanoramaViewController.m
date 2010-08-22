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
@property(nonatomic, retain) CylindricalScrollView *scrollView;

- (void)startListening;

@end

@implementation PanoramaViewController

@synthesize locationManager;
@synthesize headingLabel;
@synthesize audioManager;
@synthesize scrollView;

- (void)dealloc {
  self.locationManager = nil;
  self.headingLabel = nil;
  self.audioManager = nil;
  self.scrollView = nil;
  [super dealloc];
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  self.audioManager = [[ PanoramaAudioManager alloc ] init ];
  [ self.audioManager loadTestSounds ];
  self.scrollView = [[CylindricalScrollView alloc]
                                       initWithFrame:CGRectMake(0, 0, 1024, 768)];
  self.scrollView.imageNames = [NSArray arrayWithObjects:@"01.gif", @"02.gif", @"03.gif", @"04.gif",
                                @"05.gif", @"06.gif", @"07.gif", @"08.gif", @"09.gif", @"10.gif",
                                @"11.gif", @"12.gif", @"13.gif", @"14.gif", @"15.gif", nil];
  self.headingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(400, 0, 200, 30)] autorelease];
  self.headingLabel.text = @"Heading:";
  [self.view addSubview:self.scrollView];
  [self.view addSubview:self.headingLabel];
  [self startListening];
  [ self.audioManager startSounds ];
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
  double heading = [newHeading magneticHeading];
  self.headingLabel.text = [NSString stringWithFormat:@"Heading: %f", heading];
  [ self.audioManager updateHeading:heading];
  self.scrollView.viewAngle = heading;
}

@end
