//
//  PanoramaAudioManager.h
//  Panorama
//
//  Created by Daniel Pasco on 8/21/10.
//  Copyright 2010 Black Pixel Luminance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface PanoramaAudioManager : NSObject {
	float	_listenerPos[3];
	float	_listenerRotation;
	BOOL	_wasInterrupted;
	BOOL	_isPlaying;	
	NSMutableArray *audioSources;
}
// test method
-(void)loadTestSounds;

// Add sound
-(void)addAudioSource:(NSString *)fileName ofType:(NSString*)type atPosition:(int)position;
-(void)addAudioSource:(NSString *)fileName ofType:(NSString*)type atHeading:(int)heading;
-(void)startSounds;
-(void)stopSounds;

/**
 * Different methods for updating the current rotation angle
 */

-(void)updateHeading:(float)angle;

-(void)tearDown;
@property			BOOL isPlaying; // Whether the sound is playing or stopped
@property			BOOL wasInterrupted; // Whether playback was interrupted by the system
@property			float* listenerPos; // The coordinates of the listener
@property			float listenerRotation; // The rotation angle of the listener in radians
@property (nonatomic, retain)	NSMutableArray *audioSources;
@end
