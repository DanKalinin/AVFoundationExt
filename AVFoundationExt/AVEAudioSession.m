//
//  AVEAudioSession.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/14/18.
//  Copyright © 2018 Dan Kalinin. All rights reserved.
//

#import "AVEAudioSession.h"










@interface AVEAudioSessionInterruptionInfo ()

@property NSDictionary *dictionary;
@property AVAudioSessionInterruptionType type;
@property AVAudioSessionInterruptionOptions option;
@property BOOL wasSuspended;

@end



@implementation AVEAudioSessionInterruptionInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = super.init;
    if (self) {
        self.dictionary = dictionary;
        
        self.type = [self.dictionary[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
        self.option = [self.dictionary[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        self.wasSuspended = [self.dictionary[AVAudioSessionInterruptionWasSuspendedKey] boolValue];
    }
    return self;
}

@end










@interface AVEAudioSessionRouteChangeInfo ()

@property NSDictionary *dictionary;
@property AVAudioSessionRouteChangeReason reason;
@property AVAudioSessionRouteDescription *previousRoute;

@end



@implementation AVEAudioSessionRouteChangeInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = super.init;
    if (self) {
        self.dictionary = dictionary;
        
        self.reason = [self.dictionary[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
        self.previousRoute = self.dictionary[AVAudioSessionRouteChangePreviousRouteKey];
    }
    return self;
}

@end










@interface AVEAudioSessionSilenceSecondaryAudioHintInfo ()

@property NSDictionary *dictionary;
@property AVAudioSessionSilenceSecondaryAudioHintType type;

@end



@implementation AVEAudioSessionSilenceSecondaryAudioHintInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = super.init;
    if (self) {
        self.dictionary = dictionary;
        
        self.type = [self.dictionary[AVAudioSessionSilenceSecondaryAudioHintTypeKey] unsignedIntegerValue];
    }
    return self;
}

@end










@interface AVEAudioSessionMediaServicesWereResetInfo ()

@property NSError *error;

@end



@implementation AVEAudioSessionMediaServicesWereResetInfo

- (instancetype)initWithError:(NSError *)error {
    self = super.init;
    if (self) {
        self.error = error;
    }
    return self;
}

@end










@interface AVEAudioSession ()

@property AVAudioSession *audioSession;
@property AVEAudioSessionInterruptionInfo *interruptionInfo;
@property AVEAudioSessionRouteChangeInfo *routeChangeInfo;
@property AVEAudioSessionSilenceSecondaryAudioHintInfo *silenceSecondaryAudioHintInfo;
@property AVEAudioSessionMediaServicesWereResetInfo *mediaServicesWereResetInfo;
@property BOOL active;
@property AVAudioSessionSetActiveOptions setActiveOptions;

@end



@implementation AVEAudioSession

const NSEOperationState AVEAudioSessionStateDidConfigure = 2;

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
        
        [self.center addObserver:self selector:@selector(AVAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:self.audioSession];
        [self.center addObserver:self selector:@selector(AVAudioSessionRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:self.audioSession];
        [self.center addObserver:self selector:@selector(AVAudioSessionMediaServicesWereLostNotification:) name:AVAudioSessionMediaServicesWereLostNotification object:self.audioSession];
        [self.center addObserver:self selector:@selector(AVAudioSessionMediaServicesWereResetNotification:) name:AVAudioSessionMediaServicesWereResetNotification object:self.audioSession];
        [self.center addObserver:self selector:@selector(AVAudioSessionSilenceSecondaryAudioHintNotification:) name:AVAudioSessionSilenceSecondaryAudioHintNotification object:self.audioSession];
    }
    return self;
}

- (void)configure {
    self.threadError = nil;
    self.state = AVEAudioSessionStateDidConfigure;
}

- (void)setActive:(BOOL)active withOptions:(AVAudioSessionSetActiveOptions)options {
    NSError *error = nil;
    BOOL success = [self.audioSession setActive:active withOptions:options error:&error];
    self.threadError = error;
    if (success) {
        self.active = active;
        self.setActiveOptions = options;
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
    NSEOperationState state = self.state;
    if (state >= AVEAudioSessionStateDidConfigure) {
        [self configure];
        if (self.threadError) {
        } else {
            if (self.active) {
                [self setActive:YES withOptions:self.setActiveOptions];
            }
        }
    }
    
    self.mediaServicesWereResetInfo = [AVEAudioSessionMediaServicesWereResetInfo.alloc initWithError:self.threadError];
}

@end
