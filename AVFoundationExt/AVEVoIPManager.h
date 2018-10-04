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



@interface AVEVoIPManager : HLPOperation <AVEVoIPManagerDelegate>

@property Class sessionClass;
@property Class unitClass;
@property Class converterClass;

@property (readonly) AVEAudioSession *session;
@property (readonly) AVEAudioUnit *unit;
@property (readonly) AVEAudioConverter *converter;

- (void)initAudio;
- (void)initSession;
- (void)initUnit;
- (void)initConverter;

@end
