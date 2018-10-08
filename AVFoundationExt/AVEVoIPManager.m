//
//  AVEVoiceManager.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import "AVEVoIPManager.h"










@interface AVEVoIPAudioSession ()

@end



@implementation AVEVoIPAudioSession

- (void)configure {
    [super configure];
    
    NSError *error = nil;
    BOOL success = [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVoiceChat options:0 error:&error];
    if (success) {
        success = [self.audioSession setPreferredIOBufferDuration:0.005 error:&error];
        if (success) {
            success = [self.audioSession setPreferredSampleRate:44100.0 error:&error];
            if (success) {
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










@interface AVEVoIPAudioUnit ()

@end



@implementation AVEVoIPAudioUnit

- (void)audioComponentInstanceNew {
    [super audioComponentInstanceNew];
    
    if (self.errors.count == 0) {
        self.global.kAudioUnitProperty_MaximumFramesPerSlice = 4096;
        if (self.global.errors.count > 0) {
            [self.errors addObjectsFromArray:self.global.errors];
        } else {
            self.global.kAudioOutputUnitProperty_SetInputCallback = self.global.renderCallback;
            if (self.global.errors.count > 0) {
                [self.errors addObjectsFromArray:self.global.errors];
            } else {
                self.inputs[0].kAudioUnitProperty_SetRenderCallback = self.inputs[0].renderCallback;
                if (self.inputs[0].errors.count > 0) {
                    [self.errors addObjectsFromArray:self.inputs[0].errors];
                } else {
                    self.inputs[1].kAudioOutputUnitProperty_EnableIO = 1;
                    if (self.inputs[1].errors.count > 0) {
                        [self.errors addObjectsFromArray:self.inputs[1].errors];
                    } else {
                        self.outputs[1].kAudioUnitProperty_ShouldAllocateBuffer = 0;
                        if (self.outputs[1].errors.count > 0) {
                            [self.errors addObjectsFromArray:self.outputs[1].errors];
                        }
                    }
                }
            }
        }
    }
}

@end










@interface AVEVoIPAudioConverter ()

@end



@implementation AVEVoIPAudioConverter

@end










@interface AVEVoIPManager ()

@property AVEAudioSession *session;
@property AVEAudioUnit *unit;
@property AVEAudioConverter *converter;

@end



@implementation AVEVoIPManager

+ (instancetype)shared {
    static AVEVoIPManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self.alloc initWithSession:AVEVoIPAudioSession.shared unit:AVEVoIPAudioUnit.voiceProcessingIO converter:AVEVoIPAudioConverter.new];
    });
    return shared;
}

- (instancetype)initWithSession:(AVEAudioSession *)session unit:(AVEAudioUnit *)unit converter:(AVEAudioConverter *)converter {
    self = super.init;
    if (self) {
        self.session = session;
        [self.session.delegates addObject:self.delegates];

        self.unit = unit;
        [self.unit.delegates addObject:self.delegates];
        
        // self.converter = converter;
        // [self.converter.delegates addObject:self.delegates];
        //
        [self start];
    }
    return self;
}

- (void)start {
    [self.errors removeAllObjects];
    
    [self.session configure];
    if (self.session.errors.count > 0) {
        [self.errors addObjectsFromArray:self.session.errors];
    } else {
        [self.unit audioComponentFindNext];
        if (self.unit.errors.count > 0) {
            [self.errors addObjectsFromArray:self.unit.errors];
        } else {
            [self.unit audioComponentInstanceNew];
            if (self.unit.errors.count > 0) {
                [self.errors addObjectsFromArray:self.unit.errors];
            } else {
                [self.unit audioUnitInitialize];
                if (self.unit.errors.count > 0) {
                    [self.errors addObjectsFromArray:self.unit.errors];
                } else {
                    [self.converter start];
                    if (self.converter.errors.count > 0) {
                        [self.errors addObjectsFromArray:self.converter.errors];
                    } else {
                        //
                        [self play];
                    }
                }
            }
        }
    }
}

- (void)stop {
    [self.errors removeAllObjects];
    
    [self.unit audioUnitUninitialize];
    if (self.unit.errors.count > 0) {
        [self.errors addObjectsFromArray:self.unit.errors];
    } else {
        [self.unit audioComponentInstanceDispose];
        if (self.unit.errors.count > 0) {
            [self.errors addObjectsFromArray:self.unit.errors];
        }
    }
}

- (void)play {
    [self.errors removeAllObjects];
    
    [self.session deactivate];
    if (self.session.errors.count > 0) {
        [self.errors addObjectsFromArray:self.session.errors];
    } else {
        [self.unit audioOutputUnitStart];
        if (self.unit.errors.count > 0) {
            [self.errors addObjectsFromArray:self.unit.errors];
        }
    }
}

- (void)pause {
    [self.errors removeAllObjects];
    
    [self.unit audioOutputUnitStop];
    if (self.unit.errors.count > 0) {
        [self.errors addObjectsFromArray:self.unit.errors];
    } else {
        [self.session activate];
        if (self.session.errors.count > 0) {
            [self.errors addObjectsFromArray:self.session.errors];
        }
    }
}

//- (void)start {
//    self.session = self.sessionClass.new;
//    [self.session.delegates addObject:self.delegates];
//    [self.session start];
//
//    self.unit = [self.unitClass voiceProcessingIO];
//    [self.unit.delegates addObject:self.delegates];
//    [self.unit find];
//    [self.unit instantiate];
//    [self.unit initialize];
//
//    self.converter = self.converterClass.new;
//    [self.converter.delegates addObject:self.delegates];
//}
//
//- (void)cancel {
//    [self.session stop];
//
//    [self.unit uninitialize];
//    [self.unit dispose];
//}
//
//#pragma mark - Audio session
//
//#pragma mark - Helpers

@end
