//
//  AVEAudioSession.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/14/18.
//  Copyright © 2018 Dan Kalinin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioSessionInterruptionInfo, AVEAudioSessionRouteChangeInfo, AVEAudioSessionSilenceSecondaryAudioHintInfo, AVEAudioSession;

extern const HLPOperationState AVEAudioSessionStateDidConfigure;
extern const HLPOperationState AVEAudioSessionStateDidSetActiveNO;
extern const HLPOperationState AVEAudioSessionStateDidSetActiveYES;










@interface AVEAudioSessionInterruptionInfo : HLPObject

@property (readonly) AVAudioSessionInterruptionType type;
@property (readonly) AVAudioSessionInterruptionOptions option;
@property (readonly) BOOL wasSuspended;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end










@interface AVEAudioSessionRouteChangeInfo : HLPObject

@property (readonly) AVAudioSessionRouteChangeReason reason;
@property (readonly) AVAudioSessionRouteDescription *previousRoute;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end










@interface AVEAudioSessionSilenceSecondaryAudioHintInfo : HLPObject

@property (readonly) AVAudioSessionSilenceSecondaryAudioHintType type;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end










@protocol AVEAudioSessionDelegate <HLPOperationDelegate>

@optional
- (void)AVEAudioSessionDidUpdateState:(AVEAudioSession *)audioSession;

- (void)AVEAudioSessionDidBegin:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionDidEnd:(AVEAudioSession *)audioSession;

- (void)AVEAudioSessionInterruption:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionRouteChange:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionMediaServicesWereLost:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionSilenceSecondaryAudioHint:(AVEAudioSession *)audioSession;

@end



@interface AVEAudioSession : HLPOperation <AVEAudioSessionDelegate>

@property (readonly) HLPArray<AVEAudioSessionDelegate> *delegates;
@property (readonly) AVAudioSession *audioSession;
@property (readonly) AVEAudioSessionInterruptionInfo *interruptionInfo;
@property (readonly) AVEAudioSessionRouteChangeInfo *routeChangeInfo;
@property (readonly) AVEAudioSessionSilenceSecondaryAudioHintInfo *silenceSecondaryAudioHintInfo;

- (void)configure;
- (void)setActive:(BOOL)active withOptions:(AVAudioSessionSetActiveOptions)options;

@end
