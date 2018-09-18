//
//  AVEVoiceManager.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import "AVEVoiceManager.h"



@interface AVEVoiceManager ()

@property AUAudioUnit *unit;
@property AVAudioConverter *converter;

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
        
        NSError *error = nil;
        self.unit = [AUAudioUnit.alloc initWithComponentDescription:description error:&error];
        if (error) {
            [self.errors addObject:error];
        }
    }
    return self;
}

@end
