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

@end

@implementation PanoramaViewController

- (void)dealloc {
  [super dealloc];
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  CylindricalScrollView *scrollView = [[CylindricalScrollView alloc]
                                       initWithFrame:CGRectMake(0, 0, 1024, 768)];
  [self.view addSubview:scrollView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
  // TODO(scotty): implement this
  [super didReceiveMemoryWarning];
}

@end
