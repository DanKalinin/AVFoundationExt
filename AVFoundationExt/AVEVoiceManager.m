//
//  AVEVoiceManager.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import "AVEVoiceManager.h"










@interface AVEVoiceAudioSession ()

@end



@implementation AVEVoiceAudioSession

- (void)start {
    NSError *error = nil;
    BOOL success = [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVoiceChat options:0 error:&error];
    if (success) {
        success = [self.audioSession setPreferredIOBufferDuration:0.005 error:&error];
        if (success) {
            success = [self.audioSession setPreferredSampleRate:44100.0 error:&error];
            if (success) {
                [super start];
            } else {
                [self.errors addObject:error];
            }
        } else {
            [self.errors addObject:error];
        }
    } else {
        [self.errors addObject:error];
    }
}

@end










@interface AVEVoiceAudioUnit ()

@end



@implementation AVEVoiceAudioUnit

- (instancetype)init {
    AudioComponentDescription description = {0};
    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    self = [super initWithComponentDescription:description];
    if (self) {
        
    }
    return self;
}

@end










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
        [self initAudio];
    }
    return self;
}

#pragma mark - Audio session

- (void)AVEAudioSessionMediaServicesWereLost:(AVEAudioSession *)audioSession {
    
}

- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
    
}

#pragma mark - Helpers

- (void)initAudio {
    [self initSession];
    if (self.errors.count == 0) {
        [self initUnit];
        if (self.errors.count == 0) {
            [self initConverter];
        }
    }
}

- (void)initSession {
    self.session = AVEAudioSession.shared;
    
    NSError *error = nil;
    BOOL success = [self.session.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVoiceChat options:0 error:&error];
    if (success) {
        success = [self.session.audioSession setPreferredIOBufferDuration:0.005 error:&error];
        if (success) {
            success = [self.session.audioSession setPreferredSampleRate:44100.0 error:&error];
            if (success) {
                [self.session.delegates addObject:self.delegates];
                [self.session start];
            } else {
                [self.errors addObject:error];
            }
        } else {
            [self.errors addObject:error];
        }
    } else {
        [self.errors addObject:error];
    }
}

- (void)initUnit {
    // Global
    // Input: 0 -> 1
    // Output: 0 -> 1
    
    AudioComponentDescription description = {0};
    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    self.unit = [AVEAudioUnit.alloc initWithComponentDescription:description];
    if (self.unit.errors.count > 0) {
        [self.errors addObjectsFromArray:self.unit.errors];
    } else {
        self.unit.inputs[1].kAudioOutputUnitProperty_EnableIO = 1;
        if (self.unit.inputs[1].errors.count > 0) {
            [self.errors addObjectsFromArray:self.unit.inputs[1].errors];
        } else {
            AudioStreamBasicDescription inputFormat = self.unit.inputs[1].kAudioUnitProperty_StreamFormat;
            if (self.unit.inputs[1].errors.count > 0) {
                [self.errors addObjectsFromArray:self.unit.inputs[1].errors];
            } else {
                self.unit.inputs[0].kAudioUnitProperty_StreamFormat = inputFormat;
                if (self.unit.inputs[0].errors.count > 0) {
                    [self.errors addObjectsFromArray:self.unit.inputs[0].errors];
                } else {
                    AudioStreamBasicDescription outputFormat = self.unit.outputs[0].kAudioUnitProperty_StreamFormat;
                    if (self.unit.outputs[0].errors.count > 0) {
                        [self.errors addObjectsFromArray:self.unit.outputs[0].errors];
                    } else {
                        self.unit.outputs[1].kAudioUnitProperty_StreamFormat = outputFormat;
                        if (self.unit.outputs[1].errors.count > 0) {
                            [self.errors addObjectsFromArray:self.unit.outputs[1].errors];
                        } else {
                            self.unit.global.kAudioUnitProperty_MaximumFramesPerSlice = 4096;
                            if (self.unit.global.errors.count > 0) {
                                [self.errors addObjectsFromArray:self.unit.global.errors];
                            } else {
                                self.unit.global.kAudioOutputUnitProperty_SetInputCallback = self.unit.global.renderCallback;
                                if (self.unit.global.errors.count > 0) {
                                    [self.errors addObjectsFromArray:self.unit.global.errors];
                                } else {
                                    self.unit.inputs[0].kAudioUnitProperty_SetRenderCallback = self.unit.inputs[0].renderCallback;
                                    if (self.unit.inputs[0].errors.count > 0) {
                                        [self.errors addObjectsFromArray:self.unit.inputs[0].errors];
                                    } else {
                                        self.unit.outputs[1].kAudioUnitProperty_ShouldAllocateBuffer = 0;
                                        if (self.unit.outputs[1].errors.count > 0) {
                                            [self.errors addObjectsFromArray:self.unit.outputs[1].errors];
                                        } else {
                                            [self.unit initialize];
                                            if (self.unit.errors.count > 0) {
                                                [self.errors addObjectsFromArray:self.unit.errors];
                                            } else {
                                                [self.unit.delegates addObject:self.delegates];
                                                
                                                NSLog(@"ok");
                                                
                                                [self.session.audioSession setActive:YES error:NULL];
                                                
                                                [self.unit start];
                                                
                                                NSLog(@"ie - %u", self.unit.inputs[1].kAudioOutputUnitProperty_EnableIO);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)initConverter {
    
}

@end
