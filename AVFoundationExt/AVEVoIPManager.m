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
    NSError *error = nil;
    BOOL success = [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVoiceChat options:0 error:&error];
    NSError.threadError = error;
    if (success) {
        success = [self.audioSession setPreferredIOBufferDuration:0.005 error:&error];
        NSError.threadError = error;
        if (success) {
            success = [self.audioSession setPreferredSampleRate:44100.0 error:&error];
            NSError.threadError = error;
            if (success) {
                [super configure];
            }
        }
    }
}

@end










@interface AVEVoIPAudioUnit ()

@end



@implementation AVEVoIPAudioUnit

- (void)configure {
    self.global.kAudioUnitProperty_MaximumFramesPerSlice = 4096;
    if (NSError.threadError) {
    } else {
        self.global.kAudioOutputUnitProperty_SetInputCallback = self.global.renderCallback; // 1
        if (NSError.threadError) {
        } else {
            self.inputs[0].kAudioUnitProperty_SetRenderCallback = self.inputs[0].renderCallback; // 0
            if (NSError.threadError) {
            } else {
                self.inputs[1].kAudioOutputUnitProperty_EnableIO = 1;
                if (NSError.threadError) {
                } else {
                    self.outputs[1].kAudioUnitProperty_ShouldAllocateBuffer = 0;
                    if (NSError.threadError) {
                    } else {
                        AVAudioFormat *format = [AVAudioFormat.alloc initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100.0 channels:1 interleaved:NO];
                        self.inputs[0].kAudioUnitProperty_StreamFormat = *format.streamDescription;
                        if (NSError.threadError) {
                        } else {
                            self.outputs[1].kAudioUnitProperty_StreamFormat = *format.streamDescription;
                            if (NSError.threadError) {
                            } else {
                                [super configure];
                            }
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

- (instancetype)init {
    AVAudioFormat *fromFormat = [AVAudioFormat.alloc initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100.0 channels:1 interleaved:NO];
    
    AudioStreamBasicDescription asbd = {0};
    asbd.mSampleRate = 44100.0;
    asbd.mFormatID = kAudioFormatMPEG4AAC;
    asbd.mChannelsPerFrame = 2;
    AVAudioFormat *toFormat = [AVAudioFormat.alloc initWithStreamDescription:&asbd];
    
    self = [super initFromFormat:fromFormat toFormat:toFormat];
    if (self) {
        
    }
    return self;
}

@end










@interface AVEVoIPManager ()

@property AVEAudioUnit *unit;
@property AVEAudioConverter *converter;
@property AVEAudioSession *session;

@property NSMutableData *originalData;

@end



@implementation AVEVoIPManager

+ (instancetype)shared {
    static AVEVoIPManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = self.new;
    });
    return shared;
}

- (instancetype)init {
    self = super.init;
    if (self) {
        self.unit = AVEVoIPAudioUnit.voiceProcessingIO;
        [self.unit.delegates addObject:self.delegates];
        
        self.converter = AVEVoIPAudioConverter.new;
        [self.converter.delegates addObject:self.delegates];
        
        self.session = AVEVoIPAudioSession.shared;
        [self.session.delegates addObject:self.delegates];
        
        self.originalData = NSMutableData.data;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"size - %i", (int)self.originalData.length);
            
            // original | 10s | 2 MB | Float32, 44100, 1
        });
        
        [self initialize];
    }
    return self;
}

- (NSError *)initialize {
    [self.unit audioComponentFindNext];
    [self.unit audioComponentInstanceNew];
    [self.unit configure];
    [self.unit audioUnitInitialize];
    [self.unit audioOutputUnitStart];
    
    [self.session configure];
    [self.session setActive:YES withOptions:0];
    
    return nil;
}

- (NSError *)uninitialize {
    return nil;
}

#pragma mark - Unit

- (void)AVEAudioUnitElementDidRender:(AVEAudioUnitElement *)element {
    if (element.didRenderInfo.inBusNumber == 0) {
        [element.parent audioUnitRender:element.didRenderInfo.ioActionFlags inTimeStamp:element.didRenderInfo.inTimeStamp inOutputBusNumber:1 inNumberFrames:element.didRenderInfo.inNumberFrames ioData:element.didRenderInfo.ioData];
        element.didRenderInfo.error = NSError.threadError;
        // Receive -> Convert -> Play
        
//        NSLog(@"mNumberBuffers - %u", element.didRenderInfo.ioData->mNumberBuffers); // 1 | 2 - stereo, interleaved=NO
//        NSLog(@"mNumberChannels - %u", element.didRenderInfo.ioData->mBuffers[0].mNumberChannels); // 1 | 2 - stereo, interleaved=YES
//        NSLog(@"mDataByteSize - %u", element.didRenderInfo.ioData->mBuffers[0].mDataByteSize); // 1024
        
//        [self.originalData appendBytes:element.didRenderInfo.ioData->mBuffers[0].mData length:element.didRenderInfo.ioData->mBuffers[0].mDataByteSize];
        
        AVAudioPCMBuffer *fromBuffer = [AVAudioPCMBuffer.alloc initWithPCMFormat:self.converter.fromFormat frameCapacity:self.converter.fromFormat.streamDescription->mFramesPerPacket];
        fromBuffer.frameLength = fromBuffer.frameCapacity;
        NSLog(@"mNumberBuffers - %u", fromBuffer.audioBufferList->mNumberBuffers);
        NSLog(@"mNumberChannels - %u", fromBuffer.audioBufferList->mBuffers[0].mNumberChannels);
        NSLog(@"mDataByteSize - %u", fromBuffer.audioBufferList->mBuffers[0].mDataByteSize);
        
//        fromBuffer.frameLength = fromBuffer.frameCapacity;
//        *fromBuffer.mutableAudioBufferList = *element.didRenderInfo.ioData;
//        NSLog(@"frameLength - %u", fromBuffer.mutableAudioBufferList->mBuffers[0].mDataByteSize);
    } else {
        // Render
        // Record -> Convert -> Send
    }
}

//- (instancetype)initWithSession:(AVEAudioSession *)session unit:(AVEAudioUnit *)unit converter:(AVEAudioConverter *)converter {
//    self = super.init;
//    if (self) {
//        self.session = session;
//        [self.session.delegates addObject:self.delegates];
//
//        self.unit = unit;
//        [self.unit.delegates addObject:self.delegates];
//
//        // self.converter = converter;
//        // [self.converter.delegates addObject:self.delegates];
//        //
//        [self start];
//    }
//    return self;
//}
//
//- (void)start {
//    [self.errors removeAllObjects];
//
//    [self.session configure];
//    if (self.session.errors.count > 0) {
//        [self.errors addObjectsFromArray:self.session.errors];
//    } else {
//        [self.unit audioComponentFindNext];
//        if (self.unit.errors.count > 0) {
//            [self.errors addObjectsFromArray:self.unit.errors];
//        } else {
//            [self.unit audioComponentInstanceNew];
//            if (self.unit.errors.count > 0) {
//                [self.errors addObjectsFromArray:self.unit.errors];
//            } else {
//                [self.unit audioUnitInitialize];
//                if (self.unit.errors.count > 0) {
//                    [self.errors addObjectsFromArray:self.unit.errors];
//                } else {
//                    [self.converter start];
//                    if (self.converter.errors.count > 0) {
//                        [self.errors addObjectsFromArray:self.converter.errors];
//                    } else {
//                        //
//                        [self play];
//                    }
//                }
//            }
//        }
//    }
//}
//
//- (void)stop {
//    [self.errors removeAllObjects];
//
//    [self.unit audioUnitUninitialize];
//    if (self.unit.errors.count > 0) {
//        [self.errors addObjectsFromArray:self.unit.errors];
//    } else {
//        [self.unit audioComponentInstanceDispose];
//        if (self.unit.errors.count > 0) {
//            [self.errors addObjectsFromArray:self.unit.errors];
//        }
//    }
//}
//
//- (void)play {
//    [self.errors removeAllObjects];
//
//    [self.session deactivate];
//    if (self.session.errors.count > 0) {
//        [self.errors addObjectsFromArray:self.session.errors];
//    } else {
//        [self.unit audioOutputUnitStart];
//        if (self.unit.errors.count > 0) {
//            [self.errors addObjectsFromArray:self.unit.errors];
//        }
//    }
//}
//
//- (void)pause {
//    [self.errors removeAllObjects];
//
//    [self.unit audioOutputUnitStop];
//    if (self.unit.errors.count > 0) {
//        [self.errors addObjectsFromArray:self.unit.errors];
//    } else {
//        [self.session activate];
//        if (self.session.errors.count > 0) {
//            [self.errors addObjectsFromArray:self.session.errors];
//        }
//    }
//}
//
////- (void)start {
////    self.session = self.sessionClass.new;
////    [self.session.delegates addObject:self.delegates];
////    [self.session start];
////
////    self.unit = [self.unitClass voiceProcessingIO];
////    [self.unit.delegates addObject:self.delegates];
////    [self.unit find];
////    [self.unit instantiate];
////    [self.unit initialize];
////
////    self.converter = self.converterClass.new;
////    [self.converter.delegates addObject:self.delegates];
////}
////
////- (void)cancel {
////    [self.session stop];
////
////    [self.unit uninitialize];
////    [self.unit dispose];
////}
////
////#pragma mark - Audio session
////
////#pragma mark - Helpers

@end
