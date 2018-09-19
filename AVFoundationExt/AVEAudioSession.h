//
//  AVEAudioSession.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/14/18.
//  Copyright © 2018 Dan Kalinin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioSession;



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
@property (readonly) NSNotificationCenter *notificationCenter;
@property (readonly) AVAudioSession *audioSession;

@end
