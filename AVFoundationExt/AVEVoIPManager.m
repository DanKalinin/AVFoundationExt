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
    NSError.nseThreadError = error;
    if (success) {
        success = [self.audioSession setPreferredIOBufferDuration:0.005 error:&error];
        NSError.nseThreadError = error;
        if (success) {
            success = [self.audioSession setPreferredSampleRate:44100.0 error:&error];
            NSError.nseThreadError = error;
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
    if (NSError.nseThreadError) {
    } else {
        self.inputs[0].kAudioUnitProperty_SetRenderCallback = self.inputs[0].renderCallback;
        if (NSError.nseThreadError) {
        } else {
            self.inputs[1].kAudioOutputUnitProperty_EnableIO = 1;
            if (NSError.nseThreadError) {
            } else {
                AVAudioFormat *format = [AVAudioFormat.alloc initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100.0 channels:1 interleaved:NO];
                self.inputs[0].kAudioUnitProperty_StreamFormat = *format.streamDescription;
                if (NSError.nseThreadError) {
                } else {
                    self.outputs[1].kAudioUnitProperty_StreamFormat = *format.streamDescription;
                    if (NSError.nseThreadError) {
                    } else {
                        [super configure];
                    }
                }
            }
        }
    }
}

@end










@interface AVEVoIPInputConverter ()

@end



@implementation AVEVoIPInputConverter

- (instancetype)init {
    AVAudioFormat *fromFormat = [AVAudioFormat.alloc initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100.0 channels:1 interleaved:NO];
    
    AudioStreamBasicDescription asbd = {0};
    asbd.mSampleRate = 44100.0;
    asbd.mFormatID = kAudioFormatMPEG4AAC;
    asbd.mChannelsPerFrame = 1;
    AVAudioFormat *toFormat = [AVAudioFormat.alloc initWithStreamDescription:&asbd];
    
    self = [super initFromFormat:fromFormat toFormat:toFormat];
    return self;
}

@end










@interface AVEVoIPOutputConverter ()

@end



@implementation AVEVoIPOutputConverter

- (instancetype)init {
    AudioStreamBasicDescription asbd = {0};
    asbd.mSampleRate = 44100.0;
    asbd.mFormatID = kAudioFormatMPEG4AAC;
    asbd.mChannelsPerFrame = 1;
    AVAudioFormat *fromFormat = [AVAudioFormat.alloc initWithStreamDescription:&asbd];
    
    AVAudioFormat *toFormat = [AVAudioFormat.alloc initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100.0 channels:1 interleaved:NO];
    
    self = [super initFromFormat:fromFormat toFormat:toFormat];
    return self;
}

@end










@interface AVEVoIPManager ()

@property AVEAudioUnit *unit;
@property AVEAudioConverter *inputConverter;
@property AVEAudioConverter *outputConverter;
@property AVEAudioSession *session;

@property NSMutableData *originalData;
@property NSMutableData *compressedData;

@end



@implementation AVEVoIPManager

+ (instancetype)nseShared {
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
        
        self.inputConverter = AVEVoIPInputConverter.new;
        [self.inputConverter.delegates addObject:self.delegates];
        
        self.outputConverter = AVEVoIPOutputConverter.new;
        [self.outputConverter.delegates addObject:self.delegates];
        
        self.session = AVEVoIPAudioSession.nseShared;
        [self.session.delegates addObject:self.delegates];
        
        self.originalData = NSMutableData.data;
        self.compressedData = NSMutableData.data;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"originalData - %i", (int)self.originalData.length);
            NSLog(@"compressedData - %i", (int)self.compressedData.length);
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
    
    [self.inputConverter initialize];
    [self.inputConverter configure];
    
    [self.outputConverter initialize];
    [self.outputConverter configure];
    
    [self.session configure];
    [self.session setActive:YES withOptions:0];
    
    return nil;
}

- (NSError *)uninitialize {
    return nil;
}

#pragma mark - Unit

- (void)AVEAudioUnitElementDidRender:(AVEAudioUnitElement *)element {
    [element.parent audioUnitRender:element.didRenderInfo.ioActionFlags inTimeStamp:element.didRenderInfo.inTimeStamp inOutputBusNumber:1 inNumberFrames:element.didRenderInfo.inNumberFrames ioData:element.didRenderInfo.ioData];
    element.didRenderInfo.error = NSError.nseThreadError;
    
    AVAudioPCMBuffer *inputFromBuffer = [AVAudioPCMBuffer.alloc initWithPCMFormat:self.inputConverter.fromFormat frameCapacity:element.didRenderInfo.inNumberFrames];
    inputFromBuffer.frameLength = inputFromBuffer.frameCapacity;
    for (UInt32 index = 0; index < element.didRenderInfo.ioData->mNumberBuffers; index++) {
        memcpy(inputFromBuffer.audioBufferList->mBuffers[index].mData, element.didRenderInfo.ioData->mBuffers[index].mData, element.didRenderInfo.ioData->mBuffers[index].mDataByteSize);
    }
    
    AVAudioCompressedBuffer *inputToBuffer = [AVAudioCompressedBuffer.alloc initWithFormat:self.inputConverter.toFormat packetCapacity:1 maximumPacketSize:self.inputConverter.converter.maximumOutputPacketSize];
    
    [self.inputConverter convertToBuffer:inputToBuffer fromBuffer:inputFromBuffer];
    
    AVAudioCompressedBuffer *outputFromBuffer = inputToBuffer;
    
    AVAudioPCMBuffer *outputToBuffer = [AVAudioPCMBuffer.alloc initWithPCMFormat:self.outputConverter.toFormat frameCapacity:element.didRenderInfo.inNumberFrames];
    outputToBuffer.frameLength = outputToBuffer.frameCapacity;
    
    [self.outputConverter convertToBuffer:outputToBuffer fromBuffer:outputFromBuffer];
    
    *element.didRenderInfo.ioData = *outputToBuffer.audioBufferList;
    
    [self.originalData appendBytes:element.didRenderInfo.ioData->mBuffers[0].mData length:element.didRenderInfo.ioData->mBuffers[0].mDataByteSize];
    [self.compressedData appendBytes:inputToBuffer.data length:inputToBuffer.byteLength];
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
