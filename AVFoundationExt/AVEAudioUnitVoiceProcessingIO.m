//
//  AVEAudioUnitVoiceProcessingIO.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/25/18.
//

#import "AVEAudioUnitVoiceProcessingIO.h"



@interface AVEAudioUnitVoiceProcessingIO ()

@end



@implementation AVEAudioUnitVoiceProcessingIO

- (instancetype)init {
    self = super.init;
    if (self) {
        self.componentDescription->componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    }
    return self;
}

@end
