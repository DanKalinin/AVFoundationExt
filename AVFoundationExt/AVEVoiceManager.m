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
@property AVEAudioConverter *converter;

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
        [self.session.delegates addObject:self.delegates];
        
        [self.session.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVoiceChat options:0 error:NULL];
        [self.session.audioSession setPreferredIOBufferDuration:0.005 error:NULL];
        [self.session.audioSession setPreferredSampleRate:44100.0 error:NULL];
        
        AudioComponentDescription description = {0};
        description.componentType = kAudioUnitType_Output;
        description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
        description.componentManufacturer = kAudioUnitManufacturer_Apple;
        
        self.unit = [AVEAudioUnit.alloc initWithComponentDescription:description];
        [self.unit.delegates addObject:self.delegates];
        
        self.unit.inputs[1].kAudioOutputUnitProperty_EnableIO = 1;
        
        AudioStreamBasicDescription inputFormat = self.unit.inputs[1].kAudioUnitProperty_StreamFormat;
        self.unit.inputs[0].kAudioUnitProperty_StreamFormat = inputFormat;
        
        AudioStreamBasicDescription outputFormat = self.unit.outputs[0].kAudioUnitProperty_StreamFormat;
        self.unit.outputs[1].kAudioUnitProperty_StreamFormat = outputFormat;
        
        self.unit.global.kAudioUnitProperty_MaximumFramesPerSlice = 4096;
        
        [self.unit initialize];
        [self.unit start];
        
//        NSLog(@"ie - %u", self.unit.inputs[1].kAudioOutputUnitProperty_EnableIO);
//        NSLog(@"oe - %u", unit.outputs[0].kAudioUnitProperty_StreamFormat.mFormatID);
        
//        unit.inputs[1].kAudioUnitProperty_ElementName = @"xxx";
//        NSLog(@"name - %@", unit.inputs[1].kAudioUnitProperty_ElementName);
        
//        NSLog(@"inputs - %u", unit.global.kAudioUnitProperty_MaximumFramesPerSlice);
//        NSLog(@"outputs - %i", (int)unit.outputs.count);
//        AVEAudioUnitInstantiation *instantiation = [unit instantiateWithOptions:kAudioComponentInstantiation_LoadOutOfProcess];
//        instantiation.delegates.operationQueue = nil;
//        [instantiation waitUntilFinished];
    }
    return self;
}

#pragma mark - Audio session

- (void)AVEAudioSessionMediaServicesWereLost:(AVEAudioSession *)audioSession {
    
}

- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
    
}

@end
