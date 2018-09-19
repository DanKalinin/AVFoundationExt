//
//  AVEAudioSession.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/14/18.
//  Copyright © 2018 Dan Kalinin. All rights reserved.
//

#import "AVEAudioSession.h"



@interface AVEAudioSession ()

@property NSNotificationCenter *notificationCenter;
@property AVAudioSession *audioSession;

@end



@implementation AVEAudioSession

@dynamic delegates;

+ (instancetype)shared {
    static AVEAudioSession *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = self.new;
    });
    return shared;
}

- (instancetype)init {
    self = super.init;
    if (self) {
        self.notificationCenter = NSNotificationCenter.defaultCenter;
        self.audioSession = AVAudioSession.sharedInstance;
    }
    return self;
}

- (void)start {
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:self.audioSession];
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:self.audioSession];
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionMediaServicesWereLostNotification:) name:AVAudioSessionMediaServicesWereLostNotification object:self.audioSession];
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionMediaServicesWereResetNotification:) name:AVAudioSessionMediaServicesWereResetNotification object:self.audioSession];
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionSilenceSecondaryAudioHintNotification:) name:AVAudioSessionSilenceSecondaryAudioHintNotification object:self.audioSession];
    
    [self updateState:HLPOperationStateDidBegin];
}

- (void)cancel {
    [self.notificationCenter removeObserver:self];
    
    [self updateState:HLPOperationStateDidEnd];
}

#pragma mark - Notifications

- (void)AVAudioSessionInterruptionNotification:(NSNotification *)notification {
    [self.delegates AVEAudioSessionInterruption:self];
}

- (void)AVAudioSessionRouteChangeNotification:(NSNotification *)notification {
    [self.delegates AVEAudioSessionRouteChange:self];
}

- (void)AVAudioSessionMediaServicesWereLostNotification:(NSNotification *)notification {
    [self.delegates AVEAudioSessionMediaServicesWereLost:self];
}

- (void)AVAudioSessionMediaServicesWereResetNotification:(NSNotification *)notification {
    [self.delegates AVEAudioSessionMediaServicesWereReset:self];
}

- (void)AVAudioSessionSilenceSecondaryAudioHintNotification:(NSNotification *)notification {
    [self.delegates AVEAudioSessionSilenceSecondaryAudioHint:self];
}

//AVAudioSessionInterruptionNotification
//AVAudioSessionRouteChangeNotification
//AVAudioSessionMediaServicesWereLostNotification
//AVAudioSessionMediaServicesWereResetNotification
//AVAudioSessionSilenceSecondaryAudioHintNotification

//AVAudioSessionInterruptionTypeKey
//AVAudioSessionInterruptionOptionKey
//AVAudioSessionInterruptionWasSuspendedKey
//AVAudioSessionRouteChangeReasonKey
//AVAudioSessionRouteChangePreviousRouteKey
//AVAudioSessionSilenceSecondaryAudioHintTypeKey

@end
