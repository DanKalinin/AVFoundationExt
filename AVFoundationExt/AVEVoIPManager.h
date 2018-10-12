//
//  AVEVoiceManager.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import <Helpers/Helpers.h>
#import <AVFoundation/AVFoundation.h>
#import "AVEAudioSession.h"
#import "AVEAudioUnit.h"
#import "AVEAudioConverter.h"

@class AVEVoIPAudioSession, AVEVoIPAudioUnit, AVEVoIPAudioConverter, AVEVoIPManager;










@interface AVEVoIPAudioSession : AVEAudioSession

@end










@interface AVEVoIPAudioUnit : AVEAudioUnit

@end










@interface AVEVoIPAudioConverter : AVEAudioConverter

@end










@protocol AVEVoIPManagerDelegate <AVEAudioSessionDelegate, AVEAudioUnitDelegate, AVEAudioConverterDelegate>

@end



@interface AVEVoIPManager : NSEOperation <AVEVoIPManagerDelegate>

@property (readonly) AVEAudioUnit *unit;
@property (readonly) AVEAudioConverter *converter;
@property (readonly) AVEAudioSession *session;

- (NSError *)initialize;
- (NSError *)uninitialize;

//- (instancetype)initWithSession:(AVEAudioSession *)session unit:(AVEAudioUnit *)unit converter:(AVEAudioConverter *)converter;
//
//- (void)play;
//- (void)pause;

@end
