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

@end
