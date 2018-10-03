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
            [self.unit.delegates addObject:self.delegates];
            
            self.unit.inputs[1].kAudioOutputUnitProperty_EnableIO = 1;
            
            AudioStreamBasicDescription inputFormat = self.unit.inputs[1].kAudioUnitProperty_StreamFormat;
            self.unit.inputs[0].kAudioUnitProperty_StreamFormat = inputFormat;
            
            AudioStreamBasicDescription outputFormat = self.unit.outputs[0].kAudioUnitProperty_StreamFormat;
            self.unit.outputs[1].kAudioUnitProperty_StreamFormat = outputFormat;
            
            self.unit.global.kAudioUnitProperty_MaximumFramesPerSlice = 4096;
            
            self.unit.inputs[0].kAudioUnitProperty_SetRenderCallback = self.unit.inputs[0].renderCallback;
            
//            [self.session.audioSession setActive:YES error:NULL];
//
//            [self.unit initialize];
//            [self.unit start];
            
//            NSLog(@"ie - %u", self.unit.inputs[1].kAudioOutputUnitProperty_EnableIO);
        } @catch (HLPException *exception) {
            [self.errors addObject:exception.error];
        } @finally {
            
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
