//
//  PanoramaAudioSource.h
//  Panorama
//
//  Created by Daniel Pasco on 8/21/10.
//  Copyright 2010 Black Pixel Luminance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface PanoramaAudioSource : NSObject {
	float	angle;
	ALuint	_source;
	ALuint	_buffer;
	void	*_data;
	float	_sourcePos[3];
	ALfloat	_sourceVolume;	
}

- (void)startSound;
- (void)stopSound;


@property			float* sourcePos; // The coordinates of the sound source
@property			ALfloat sourceVolume; // The coordinates of the sound source

@end
