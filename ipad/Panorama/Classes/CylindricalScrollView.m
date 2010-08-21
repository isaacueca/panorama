//
//  CylindricalScrollView.m
//  Panorama
//
//  Created by Scotty Allen on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CylindricalScrollView.h"


@implementation CylindricalScrollView

@synthesize imageNames;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.imageNames = [NSArray arrayWithObject:@"1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    imageView.image = [UIImage imageNamed:[self.imageNames objectAtIndex:0]];
    [self addSubview:imageView];
  }
  return self;
}

- (void)dealloc {
  self.imageNames = nil;
  [super dealloc];
}

- (void)rotateTo:(double)angle {
}

@end
