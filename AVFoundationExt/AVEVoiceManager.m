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
        @try {
            self.session = AVEAudioSession.shared;
            [self.session.delegates addObject:self.delegates];
            
            NSError *error = nil;
            [self.session.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVoiceChat options:0 error:&error];
            [HLPException raiseWithError:error];
            [self.session.audioSession setPreferredIOBufferDuration:0.005 error:&error];
            [HLPException raiseWithError:error];
            [self.session.audioSession setPreferredSampleRate:44100.0 error:&error];
            [HLPException raiseWithError:error];
            
            AudioComponentDescription description = {0};
            description.componentType = kAudioUnitType_Output;
            description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
            description.componentManufacturer = kAudioUnitManufacturer_Apple;
            
            self.unit = [AVEAudioUnit.alloc initWithComponentDescription:description];
            [HLPException raiseWithError:self.unit.errors.firstObject];
            [self.unit.delegates addObject:self.delegates];
            
            self.unit.inputs[1].kAudioOutputUnitProperty_EnableIO = 1;
            [HLPException raiseWithError:self.unit.inputs[1].errors.firstObject];
            
            AudioStreamBasicDescription inputFormat = self.unit.inputs[1].kAudioUnitProperty_StreamFormat;
            [HLPException raiseWithError:self.unit.inputs[1].errors.firstObject];
            self.unit.inputs[0].kAudioUnitProperty_StreamFormat = inputFormat;
            [HLPException raiseWithError:self.unit.inputs[0].errors.firstObject];
            
            AudioStreamBasicDescription outputFormat = self.unit.outputs[0].kAudioUnitProperty_StreamFormat;
            [HLPException raiseWithError:self.unit.outputs[0].errors.firstObject];
            self.unit.outputs[1].kAudioUnitProperty_StreamFormat = outputFormat;
            [HLPException raiseWithError:self.unit.outputs[1].errors.firstObject];
            
            self.unit.global.kAudioUnitProperty_MaximumFramesPerSlice = 4096;
            [HLPException raiseWithError:self.unit.global.errors.firstObject];
            
            self.unit.inputs[0].kAudioUnitProperty_SetRenderCallback = self.unit.inputs[0].renderCallback;
            [HLPException raiseWithError:self.unit.inputs[0].errors.firstObject];
            
            [self.unit initialize];
            [HLPException raiseWithError:self.unit.errors.firstObject];
            
//            [self.session.audioSession setActive:YES error:NULL];
//
//            [self.unit initialize];
//            [self.unit start];
            
//            NSLog(@"ie - %u", self.unit.inputs[1].kAudioOutputUnitProperty_EnableIO);
        } @catch (HLPException *exception) {
            [self.errors addObject:exception.error];
        }
    }
    return self;
}

#pragma mark - Audio session

- (void)AVEAudioSessionMediaServicesWereLost:(AVEAudioSession *)audioSession {
    
}

- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
    
}

@end
