//
//  CylindricalScrollView.m
//  Panorama
//
//  Created by Scotty Allen on 8/21/10.
//  Copyright 2010. All rights reserved.
//

#import "CylindricalScrollView.h"

float SCREEN_WIDTH = 1024.0;

@interface CylindricalScrollView ()

- (void)updateImageViews;
@property(nonatomic, retain) NSMutableArray *imageViews;

@end

@implementation CylindricalScrollView

@synthesize imageViews;
@synthesize imageNames;
@synthesize viewAngle;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    viewAngle = 0;
    pixelsPerDegree = 0;
    self.imageViews = [NSMutableArray array];
    imageNames = [[NSArray alloc] init];
  }
  return self;
}

- (void)dealloc {
  self.imageNames = nil;
  self.imageViews = nil;
  [super dealloc];
}

- (void)setImageNames:(NSArray *)someImageNames {
  // TODO(scotty): do any necessary cleanup if this is called a second time.
  [someImageNames retain];
  [imageNames release];
  imageNames = someImageNames;

  // Allocate a fixed size array to store image views in.
  self.imageViews = [NSMutableArray arrayWithCapacity:[someImageNames count]];
  for (int i = 0; i < [someImageNames count]; i++) {
    [self.imageViews addObject:[NSNull null]];
  }

  pixelsPerDegree = ([someImageNames count] * SCREEN_WIDTH) / 360.0;

  [self updateImageViews];
}

- (void)setViewAngle:(double)angle {
  viewAngle = angle;
  [self updateImageViews];
}

- (void) createImageViewForIndex: (int) currImageIndex  {
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
  NSString *imageName = [self.imageNames objectAtIndex:currImageIndex];
  NSLog(@"loading image %@", imageName);
  imageView.image = [UIImage imageNamed:imageName];
  imageView.opaque = NO;
  [self.imageViews replaceObjectAtIndex:currImageIndex withObject:imageView];
  [self addSubview:imageView];
  [ imageView release ];
}

- (void)updateImageViews {
  double pixelOffset = self.viewAngle * pixelsPerDegree;

  int currImageIndex = pixelOffset / SCREEN_WIDTH;
  int prevImageIndex = currImageIndex - 1;
  if (prevImageIndex < 0) {
    prevImageIndex = [self.imageNames count] - 1;
  }
  int nextImageIndex = currImageIndex + 1;
  if (nextImageIndex >= [self.imageNames count]) {
    nextImageIndex = 0;
  }

  // Remove any image views we're not using
  NSUInteger i, count = [self.imageViews count];
  for (i = 0; i < count; i++) {
    UIImageView *imageView = [self.imageViews objectAtIndex:i];
    if ((id)imageView == [NSNull null] ||
        i == currImageIndex || i == prevImageIndex || i == nextImageIndex) {
      continue;
    }
    [imageView removeFromSuperview];
    [self.imageViews replaceObjectAtIndex:i withObject:[NSNull null]];
  }

  // TODO(scotty): Recycle image views

  // Add any images we need
  if ([self.imageViews objectAtIndex:prevImageIndex] == [NSNull null]) {
    [self createImageViewForIndex:prevImageIndex];
  }

  if ([self.imageViews objectAtIndex:currImageIndex] == [NSNull null]) {
    [self createImageViewForIndex: currImageIndex];
  }

  if ([self.imageViews objectAtIndex:nextImageIndex] == [NSNull null]) {
    [self createImageViewForIndex:nextImageIndex];
  }

  // Set the image offsets
  UIImageView *prevImageView = [self.imageViews objectAtIndex:prevImageIndex];
  CGRect frame = prevImageView.frame;
  frame.origin.x = prevImageIndex * SCREEN_WIDTH - pixelOffset;
  prevImageView.frame = frame;

  UIImageView *middleImageView = [self.imageViews objectAtIndex:currImageIndex];
  frame = middleImageView.frame;
  frame.origin.x = currImageIndex * SCREEN_WIDTH - pixelOffset;
  middleImageView.frame = frame;

  UIImageView *nextImageView = [self.imageViews objectAtIndex:nextImageIndex];
  frame = nextImageView.frame;
  if (nextImageIndex == 0 && [self.imageNames count] * SCREEN_WIDTH - pixelOffset < pixelOffset) {
    frame.origin.x = [self.imageNames count] * SCREEN_WIDTH - pixelOffset;
  } else {
    frame.origin.x = nextImageIndex * SCREEN_WIDTH - pixelOffset;
  }
  nextImageView.frame = frame;
}

@end
