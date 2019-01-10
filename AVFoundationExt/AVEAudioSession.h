//
//  AVEAudioSession.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/14/18.
//  Copyright © 2018 Dan Kalinin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <FoundationExt/FoundationExt.h>

@class AVEAudioSessionInterruptionInfo;
@class AVEAudioSessionRouteChangeInfo;
@class AVEAudioSessionSilenceSecondaryAudioHintInfo;
@class AVEAudioSessionMediaServicesWereResetInfo;
@class AVEAudioSession;










@interface AVEAudioSessionInterruptionInfo : HLPObject

@property (readonly) NSDictionary *dictionary;
@property (readonly) AVAudioSessionInterruptionType type;
@property (readonly) AVAudioSessionInterruptionOptions option;
@property (readonly) BOOL wasSuspended;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end










@interface AVEAudioSessionRouteChangeInfo : HLPObject

@property (readonly) NSDictionary *dictionary;
@property (readonly) AVAudioSessionRouteChangeReason reason;
@property (readonly) AVAudioSessionRouteDescription *previousRoute;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end










@interface AVEAudioSessionSilenceSecondaryAudioHintInfo : HLPObject

@property (readonly) NSDictionary *dictionary;
@property (readonly) AVAudioSessionSilenceSecondaryAudioHintType type;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end










@interface AVEAudioSessionMediaServicesWereResetInfo : HLPObject

@property (readonly) NSError *error;

- (instancetype)initWithError:(NSError *)error;

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

@property (readonly) NSEOrderedSet<AVEAudioSessionDelegate> *delegates;
@property (readonly) AVAudioSession *audioSession;
@property (readonly) AVEAudioSessionInterruptionInfo *interruptionInfo;
@property (readonly) AVEAudioSessionRouteChangeInfo *routeChangeInfo;
@property (readonly) AVEAudioSessionSilenceSecondaryAudioHintInfo *silenceSecondaryAudioHintInfo;
@property (readonly) AVEAudioSessionMediaServicesWereResetInfo *mediaServicesWereResetInfo;
@property (readonly) BOOL active;
@property (readonly) AVAudioSessionSetActiveOptions setActiveOptions;

- (void)configure;
- (void)setActive:(BOOL)active withOptions:(AVAudioSessionSetActiveOptions)options;

@end
