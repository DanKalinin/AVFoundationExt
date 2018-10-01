//
//  AVEVoiceManager.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import "AVEVoiceManager.h"



@interface AVEVoiceManager ()

@property AVEAudioSession *session;
@property AVEAudioUnit *unit;

@end



@implementation AVEVoiceManager

+ (instancetype)shared {
    static AVEVoiceManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = self.new;
    });
    return shared;
}

- (instancetype)init {
    self = super.init;
    if (self) {
        self.session = AVEAudioSession.shared;
        
        AudioComponentDescription description = {0};
        description.componentType = kAudioUnitType_Output;
        description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
        description.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        AVEAudioUnit *unit = [AVEAudioUnit.alloc initWithComponentDescription:description];
        
        AVEAudioUnitInstantiation *instantiation = [unit instantiateWithOptions:kAudioComponentInstantiation_LoadOutOfProcess];
        instantiation.delegates.operationQueue = nil;
        [instantiation waitUntilFinished];
    }
    return self;
}

@end
