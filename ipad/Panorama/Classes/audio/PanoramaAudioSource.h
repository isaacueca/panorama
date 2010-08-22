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
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PanoramaAudioSource : NSObject {
	float	angle;
	float   volume;
	ALuint	_source;
	ALuint	_buffer;
	void	*_data;
	float	_sourcePos[3];
	ALfloat	_sourceVolume;	
	NSString *fileName;
	NSString *extension;
	BOOL isStarted;
	AVAudioPlayer *player;
}

-(void)initSource;
- (void)startSound;
- (void)stopSound;

@property float* sourcePos; // The coordinates of the sound source
@property ALfloat sourceVolume; // The coordinates of the sound source
@property float	angle;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *extension;
@property float volume;
@property BOOL isStarted;

@end
