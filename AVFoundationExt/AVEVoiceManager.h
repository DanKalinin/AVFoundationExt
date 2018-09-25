//
//  AVEVoiceManager.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import <Helpers/Helpers.h>
#import <AVFoundation/AVFoundation.h>
#import "AVEAudioSession.h"
#import "AVEAudioUnitVoiceProcessingIO.h"

@class AVEVoiceManager;



@protocol AVEVoiceManagerDelegate <HLPOperationDelegate>

@end



@interface AVEVoiceManager : HLPOperation <AVEVoiceManagerDelegate>

@property (readonly) AVEAudioSession *session;
@property (readonly) AVEAudioUnitVoiceProcessingIO *unit;

@end
