//
//  AVEVoiceManager.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import "AVEVoiceManager.h"



@interface AVEVoiceManager ()

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
        AudioComponentDescription description = {0};
        description.componentType = kAudioUnitType_Output;
        description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
        description.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        AudioComponent component = AudioComponentFindNext(NULL, &description);
        
        AudioUnit unit;
        OSStatus status = AudioComponentInstanceNew(component, &unit);
        if (status == noErr) {
        } else {
            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
            [self.errors addObject:error];
        }
    }
    return self;
}

@end
