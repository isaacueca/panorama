//
//  PanoramaAudioManager.m
//  Panorama
//
//  Created by Daniel Pasco on 8/21/10.
//  Copyright 2010 Black Pixel Luminance. All rights reserved.
//

#import "PanoramaAudioManager.h"
#import "PanoramaAudioSource.h"
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PanoramaAudioManager(private)
- (void)initOpenAL;
- (void)teardownOpenAL;
@end

@implementation PanoramaAudioManager
@synthesize isPlaying = _isPlaying; // Whether the sound is playing or stopped
@synthesize wasInterrupted = _wasInterrupted;
@synthesize listenerRotation = _listenerRotation;
@synthesize audioSources;
void interruptionListener(	void *	inClientData,
						  UInt32	inInterruptionState)
{
	PanoramaAudioManager *THIS = (PanoramaAudioManager*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		// do nothing
		[THIS teardownOpenAL];
		if ([THIS isPlaying]) {
			THIS->_wasInterrupted = YES;
			THIS->_isPlaying = NO;
		}
	}
	else if (inInterruptionState == kAudioSessionEndInterruption)
	{
		OSStatus result = AudioSessionSetActive(true);
		if (result) printf("Error setting audio session active! %d\n", (int)result);
		[THIS initOpenAL];
		if (THIS->_wasInterrupted)
		{
			[THIS startSounds];			
			THIS->_wasInterrupted = NO;
		}
	}
}
#pragma mark init and dealloc
-(id)init {
	if(self = [ super init ]) {
		self.audioSources = [ NSMutableArray array ];
	}
	return self;
}

-(void)dealloc {
	[ audioSources release ], audioSources = nil;
	[ super dealloc ];
}

#pragma mark sound management
-(void)addAudioSource:(NSString *)fileName ofType:(NSString*)type atHeading:(int)heading {
	
}

-(void)addAudioSource:(NSString *)fileName ofType:(NSString*)type atPosition:(int)position {
	
}

-(void)loadTestSounds {
	
}

- (void)initOpenAL {
	ALCcontext		*newContext = NULL;
	ALCdevice		*newDevice = NULL;
	
	// Create a new OpenAL Device
	// Pass NULL to specify the system’s default output device
	newDevice = alcOpenDevice(NULL);
	if (newDevice != NULL) {
		// Create a new OpenAL Context
		// The new context will render to the OpenAL Device just created 
		newContext = alcCreateContext(newDevice, 0);
		if (newContext != NULL) {
			// Make the new context the Current OpenAL Context
			alcMakeContextCurrent(newContext);
		}
	}
	// clear any errors
	alGetError();
}

-(void)startSounds {
	[ self initOpenAL ];
	for(PanoramaAudioSource *source in self.audioSources) {
		[ source startSound ];
	}
}

- (void)teardownOpenAL {
    ALCcontext	*context = NULL;
    ALCdevice	*device = NULL;
	
	
	//Get active context (there can only be one)
    context = alcGetCurrentContext();
    //Get device for active context
    device = alcGetContextsDevice(context);
    //Release context
    alcDestroyContext(context);
    //Close device
    alcCloseDevice(device);
}

-(void)stopSounds {
	for(PanoramaAudioSource *source in self.audioSources) {
		[ source stopSound ];
	}
}

-(void)tearDown {
	[ self stopSounds ];
	[ self teardownOpenAL ];
}

#pragma mark angular update
- (float)listenerRotation {
	return _listenerRotation;
}

- (void)setListenerRotation:(float)radians {
	_listenerRotation = radians;
	float ori[] = {0., cos(radians), sin(radians), 1., 0., 0.};
	// Set our listener orientation (rotation)
	alListenerfv(AL_ORIENTATION, ori);
}

-(void)updatePosition:(int)pixel {
	
}

-(void)updateHeading:(float)angle {
	
}


#pragma mark position update
- (float*)listenerPos{
	return _listenerPos;
}

- (void)setListenerPos:(float*)LISTENERPOS {
	int i;
	for (i=0; i<3; i++)
		_listenerPos[i] = LISTENERPOS[i];
	
	// Move our listener coordinates
	alListenerfv(AL_POSITION, _listenerPos);
}

@end