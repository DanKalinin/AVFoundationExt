//
//  AVEAudioSession.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/14/18.
//  Copyright © 2018 Dan Kalinin. All rights reserved.
//

#import "AVEAudioSession.h"

const HLPOperationState AVEAudioSessionStateDidConfigure = 6;
const HLPOperationState AVEAudioSessionStateDidDeconfigure = 7;
const HLPOperationState AVEAudioSessionStateDidActivate = 8;
const HLPOperationState AVEAudioSessionStateDidDeactivate = 9;










@interface AVEAudioSessionInterruptionInfo ()

@property AVAudioSessionInterruptionType type;
@property AVAudioSessionInterruptionOptions option;
@property BOOL wasSuspended;

@end



@implementation AVEAudioSessionInterruptionInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = super.init;
    if (self) {
        self.type = [dictionary[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
        self.option = [dictionary[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        self.wasSuspended = [dictionary[AVAudioSessionInterruptionWasSuspendedKey] boolValue];
    }
    return self;
}

@end










@interface AVEAudioSessionRouteChangeInfo ()

@property AVAudioSessionRouteChangeReason reason;
@property AVAudioSessionRouteDescription *previousRoute;

@end



@implementation AVEAudioSessionRouteChangeInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = super.init;
    if (self) {
        self.reason = [dictionary[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
        self.previousRoute = dictionary[AVAudioSessionRouteChangePreviousRouteKey];
    }
    return self;
}

@end










@interface AVEAudioSessionSilenceSecondaryAudioHintInfo ()

@property AVAudioSessionSilenceSecondaryAudioHintType type;

@end



@implementation AVEAudioSessionSilenceSecondaryAudioHintInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = super.init;
    if (self) {
        self.type = [dictionary[AVAudioSessionSilenceSecondaryAudioHintTypeKey] unsignedIntegerValue];
    }
    return self;
}

@end










@interface AVEAudioSession ()

@property AVAudioSession *audioSession;
@property AVEAudioSessionInterruptionInfo *interruptionInfo;
@property AVEAudioSessionRouteChangeInfo *routeChangeInfo;
@property AVEAudioSessionSilenceSecondaryAudioHintInfo *silenceSecondaryAudioHintInfo;

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
        self.audioSession = AVAudioSession.sharedInstance;
        [self start];
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

- (void)start {
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:self.audioSession];
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:self.audioSession];
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionMediaServicesWereLostNotification:) name:AVAudioSessionMediaServicesWereLostNotification object:self.audioSession];
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionMediaServicesWereResetNotification:) name:AVAudioSessionMediaServicesWereResetNotification object:self.audioSession];
    [self.notificationCenter addObserver:self selector:@selector(AVAudioSessionSilenceSecondaryAudioHintNotification:) name:AVAudioSessionSilenceSecondaryAudioHintNotification object:self.audioSession];
    
    [self updateState:HLPOperationStateDidBegin];
}

- (void)configure {
    [self.states removeAllObjects];
    [self.errors removeAllObjects];
    
    self.state = AVEAudioSessionStateDidConfigure;
    [self updateState:AVEAudioSessionStateDidConfigure];
}

- (void)deconfigure {
    [self.states removeAllObjects];
    
    self.state = HLPOperationStateDidStart;
    [self updateState:AVEAudioSessionStateDidDeconfigure];
}

- (void)activate {
    [self.states removeAllObjects];
    [self.errors removeAllObjects];
    
    NSError *error = nil;
    BOOL success = [self.audioSession setActive:YES withOptions:0 error:&error];
    if (success) {
        self.state = AVEAudioSessionStateDidActivate;
        [self updateState:AVEAudioSessionStateDidActivate];
    } else {
        [self.errors addObject:error];
    }
}

- (void)deactivate {
    [self.states removeAllObjects];
    [self.errors removeAllObjects];
    
    NSError *error = nil;
    BOOL success = [self.audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (success) {
        self.state = AVEAudioSessionStateDidConfigure;
        [self updateState:AVEAudioSessionStateDidDeactivate];
    } else {
        [self.errors addObject:error];
    }
}

#pragma mark - Notifications

- (void)AVAudioSessionInterruptionNotification:(NSNotification *)notification {
    self.interruptionInfo = [AVEAudioSessionInterruptionInfo.alloc initWithDictionary:notification.userInfo];
    [self.delegates AVEAudioSessionInterruption:self];
}

- (void)AVAudioSessionRouteChangeNotification:(NSNotification *)notification {
    self.routeChangeInfo = [AVEAudioSessionRouteChangeInfo.alloc initWithDictionary:notification.userInfo];
    [self.delegates AVEAudioSessionRouteChange:self];
}

- (void)AVAudioSessionMediaServicesWereLostNotification:(NSNotification *)notification {
    [self.delegates AVEAudioSessionMediaServicesWereLost:self];
}

- (void)AVAudioSessionMediaServicesWereResetNotification:(NSNotification *)notification {
    [self.delegates AVEAudioSessionMediaServicesWereReset:self];
}

- (void)AVAudioSessionSilenceSecondaryAudioHintNotification:(NSNotification *)notification {
    self.silenceSecondaryAudioHintInfo = [AVEAudioSessionSilenceSecondaryAudioHintInfo.alloc initWithDictionary:notification.userInfo];
    [self.delegates AVEAudioSessionSilenceSecondaryAudioHint:self];
}

#pragma mark - Audio session

- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
    HLPOperationState state = self.state;
    if (state >= AVEAudioSessionStateDidConfigure) {
        [self configure];
        if (self.errors.count == 0) {
            if (state >= AVEAudioSessionStateDidActivate) {
                [self activate];
            }
        }
    }
}

@end
