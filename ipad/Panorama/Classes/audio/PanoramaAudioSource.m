//
//  PanoramaAudioSource.m
//  Panorama
//
//  Created by Daniel Pasco on 8/21/10.
//  Copyright 2010 Black Pixel Luminance. All rights reserved.
//

#import "PanoramaAudioSource.h"
#import "OpenALSupport.h"

#define kAudioSourceRadius 1.0f

@implementation PanoramaAudioSource
@synthesize sourceVolume;
@synthesize fileName, extension;
@synthesize angle;
@synthesize volume;

-(void)dealloc {
	[ fileName release ], fileName = nil;
	[ extension release ], extension = nil;
	[ super dealloc ];
}

- (void) initBuffer {
	ALenum  error = AL_NO_ERROR;
	ALenum  format;
	ALsizei size;
	ALsizei freq;
	
	NSBundle*				bundle = [NSBundle mainBundle];
	
	// get some audio data from a wave file
	CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:self.fileName ofType:self.extension]] retain];
	
	if (fileURL) {	
		_data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
		CFRelease(fileURL);
		
		if((error = alGetError()) != AL_NO_ERROR) {
			printf("error loading sound: %x\n", error);
			exit(1);
		}
		
		// use the static buffer data API
		alBufferDataStaticProc(_buffer, format, _data, size, freq);
		
		if((error = alGetError()) != AL_NO_ERROR) {
			printf("error attaching audio to buffer: %x\n", error);
		}		
	}
	else {
		printf("Could not find file!\n");
		_data = NULL;
	}
}

- (void) initSource {
	ALenum error = AL_NO_ERROR;
	alGetError(); // Clear the error
    
	// Turn Looping ON
	alSourcei(_source, AL_LOOPING, AL_TRUE);
	
	// Set Source Position
	alSourcefv(_source, AL_POSITION, _sourcePos);
	
	// Set Source Reference Distance
	alSourcef(_source, AL_REFERENCE_DISTANCE, 1.0f);
	
	// attach OpenAL Buffer to OpenAL Source
	alSourcei(_source, AL_BUFFER, _buffer);
	
	if((error = alGetError()) != AL_NO_ERROR) {
		printf("Error attaching buffer to source: %x\n", error);
		exit(1);
	}	
}

- (void)startSound {
	ALenum error;
	// Create some OpenAL Buffer Objects
	alGenBuffers(1, &_buffer);
	if((error = alGetError()) != AL_NO_ERROR) {
		printf("Error Generating Buffers: %x", error);
		exit(1);
	}
	
	// Create some OpenAL Source Objects
	alGenSources(1, &_source);
	if(alGetError() != AL_NO_ERROR)  {
		printf("Error generating sources! %x\n", error);
		exit(1);
	}
	
	[self initBuffer];	
	[self initSource];

	printf("Start!\n");
	// Begin playing our source file
	alSourcePlay(_source);
	if((error = alGetError()) != AL_NO_ERROR) {
		printf("error starting source: %x\n", error);
	}
}

- (void)stopSound {
	ALenum error;
	
	printf("Stop!!\n");
	// Stop playing our source file
	alSourceStop(_source);
	if((error = alGetError()) != AL_NO_ERROR) {
		printf("error stopping source: %x\n", error);
	}
	
	// Delete the Sources
    alDeleteSources(1, &_source);
	// Delete the Buffers
    alDeleteBuffers(1, &_buffer);	
}

- (float*)sourcePos {
	return _sourcePos;
}

- (void)setSourcePos:(float*)SOURCEPOS {
	int i;
	for (i=0; i<3; i++)
		_sourcePos[i] = SOURCEPOS[i];
	
	// Move our audio source coordinates
	alSourcefv(_source, AL_POSITION, _sourcePos);
}

-(void)setAngle:(float)_angle {
	angle = _angle*M_PI/180.0f;
	
	self.sourcePos[0] = kAudioSourceRadius*cos(angle);
	self.sourcePos[1] = kAudioSourceRadius*sin(angle);
	self.sourcePos[2] = 0.0f;
}

-(void)setVolume:(float)_volume {
//	NSLog(@"setting gain to %2.2f", _volume);
	alSourcef(_source, AL_GAIN, _volume);
}
@end
