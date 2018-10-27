//
//  AVEAudioSession.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/14/18.
//  Copyright © 2018 Dan Kalinin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioSessionInterruptionInfo;
@class AVEAudioSessionRouteChangeInfo;
@class AVEAudioSessionSilenceSecondaryAudioHintInfo;
@class AVEAudioSession;










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










@protocol AVEAudioSessionDelegate <NSEOperationDelegate>

@optional
- (void)AVEAudioSessionInterruption:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionRouteChange:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionMediaServicesWereLost:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession;
- (void)AVEAudioSessionSilenceSecondaryAudioHint:(AVEAudioSession *)audioSession;

@end



@interface AVEAudioSession : NSEOperation <AVEAudioSessionDelegate>

extern const NSEOperationState AVEAudioSessionStateDidConfigure;

@property (readonly) HLPArray<AVEAudioSessionDelegate> *delegates;
@property (readonly) AVAudioSession *audioSession;
@property (readonly) AVEAudioSessionInterruptionInfo *interruptionInfo;
@property (readonly) AVEAudioSessionRouteChangeInfo *routeChangeInfo;
@property (readonly) AVEAudioSessionSilenceSecondaryAudioHintInfo *silenceSecondaryAudioHintInfo;
@property (readonly) BOOL active;
@property (readonly) AVAudioSessionSetActiveOptions setActiveOptions;

- (NSError *)configure;
- (NSError *)setActive:(BOOL)active withOptions:(AVAudioSessionSetActiveOptions)options;

@end
