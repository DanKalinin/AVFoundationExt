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

@class AVEVoIPAudioSession;
@class AVEVoIPAudioUnit;
@class AVEVoIPAudioConverter;
@class AVEVoIPManager;










@interface AVEVoIPAudioSession : AVEAudioSession

@end










@interface AVEVoIPAudioUnit : AVEAudioUnit

@end










@interface AVEVoIPInputConverter : AVEAudioConverter

@end










@interface AVEVoIPOutputConverter : AVEAudioConverter

@end










@protocol AVEVoIPManagerDelegate <AVEAudioSessionDelegate, AVEAudioUnitDelegate, AVEAudioConverterDelegate>

@end



@interface AVEVoIPManager : NSEOperation <AVEVoIPManagerDelegate>

@property (readonly) AVEAudioUnit *unit;
@property (readonly) AVEAudioConverter *inputConverter;
@property (readonly) AVEAudioConverter *outputConverter;
@property (readonly) AVEAudioSession *session;

- (NSError *)initialize;
- (NSError *)uninitialize;

//- (instancetype)initWithSession:(AVEAudioSession *)session unit:(AVEAudioUnit *)unit converter:(AVEAudioConverter *)converter;
//
//- (void)play;
//- (void)pause;

@end
