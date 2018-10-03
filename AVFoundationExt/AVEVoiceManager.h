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

@class AVEVoiceAudioSession, AVEVoiceAudioUnit, AVEVoiceManager;










@interface AVEVoiceAudioSession : AVEAudioSession

@end










@interface AVEVoiceAudioUnit : AVEAudioUnit

@end










@protocol AVEVoiceManagerDelegate <AVEAudioSessionDelegate, AVEAudioUnitDelegate, AVEAudioConverterDelegate>

@end



@interface AVEVoiceManager : HLPOperation <AVEVoiceManagerDelegate>

@property (readonly) AVEAudioSession *session;
@property (readonly) AVEAudioUnit *unit;
@property (readonly) AVEAudioConverter *converter;

- (void)initAudio;
- (void)initSession;
- (void)initUnit;
- (void)initConverter;

@end
