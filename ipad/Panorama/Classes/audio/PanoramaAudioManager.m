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
@synthesize started;

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
	if (self = [super init]) {
		// initial position of the sound source and 
		// initial position and rotation of the listener
		// will be set by the view
		self.audioSources = [ NSMutableArray array ];
		
//		// setup our audio session
//		OSStatus result = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
//		if (result) printf("Error initializing audio session! %d\n", (int)result);
//		else {
//			UInt32 category = kAudioSessionCategory_AmbientSound;
//			result = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
//			if (result) printf("Error setting audio session category! %d\n", (int)result);
//			else {
//				result = AudioSessionSetActive(true);
//				if (result) printf("Error setting audio session active! %d\n", (int)result);
//			}
//		}
//		
//		_wasInterrupted = NO;
//		
//		// Initialize our OpenAL environment
//		[self initOpenAL];
		self.listenerPos[0] = 0.0f;
		self.listenerPos[1] = 0.0f;
		self.listenerPos[2] = 0.0f;
	}
	return self;
}

-(void)dealloc {
	[ audioSources release ], audioSources = nil;
	[ self tearDown ];
	[ super dealloc ];
}

#pragma mark sound management
-(void)addAudioSource:(NSString *)fileName ofType:(NSString*)type atHeading:(int)heading {
	
}

-(void)addAudioSource:(NSString *)fileName ofType:(NSString*)type atPosition:(int)position {
	
}

-(void)loadTestSounds {
	
	for(int i = 0; i< 7; i++) {
		PanoramaAudioSource *source = [[ PanoramaAudioSource alloc ] init ];
		source.angle = i*45;
//		if(i==0) {
//			source.fileName = @"leeight";
//			source.extension = @"caf";
//		}
//		else if(i==1) {
//			source.fileName = @"leseven";
//			source.extension = @"caf";
//		}
		if(i==2) {
			source.angle = 305;
			source.fileName = @"Italy_01";
			source.extension = @"caf";
		}
		else if(i==3) {
			source.angle = 100;
			source.fileName = @"Spain_01";
			source.extension = @"caf";
		}
//		else if(i==4) {
//			source.fileName = @"Portugal";
//			source.extension = @"caf";
//		}
//		else {
//			source.fileName = [ NSString stringWithFormat:@"%i", (i+1) ];
//			source.extension = @"caf";
//		}
		[ self.audioSources addObject:source];
		[ source release ];
	}
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
	started = YES;
	for(PanoramaAudioSource *source in self.audioSources) {
		if(!source.isStarted)
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
		if(source.isStarted)
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
	float ori[] = {cos(radians), sin(radians), 1.0f, 0.0f, 0., 1.0f};
	// Set our listener orientation (rotation)
	alListenerfv(AL_ORIENTATION, ori);
}

-(void)updateHeading:(float)angle {
	float radians = -angle*M_PI/180.0f;
	[ self setListenerRotation:radians];
	float x = cos(radians);
	float y = sin(radians);
	
	for(PanoramaAudioSource *source in self.audioSources) {
		// This currently works because everything is at a unit radius
		float dotProduct = x*source.sourcePos[0] + y*source.sourcePos[1];
		float distance = dotProduct - 0.8f;
		float volume = 0.0;
		if(distance > 0.0f) {
			volume = distance*5.0f;
			//if(!source.isStarted) [ source startSound ];
			source.volume = volume;
		}
		else {
//			if(source.isStarted) [ source stopSound ];
			source.volume = volume;
		}
	}
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
