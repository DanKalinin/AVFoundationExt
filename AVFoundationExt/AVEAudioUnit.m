//
//  AVEAudioUnit.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import "AVEAudioUnit.h"

const NSEOperationState AVEAudioUnitStateDidAudioComponentFindNext = 2;
const NSEOperationState AVEAudioUnitStateDidAudioComponentInstanceDispose = 3;
const NSEOperationState AVEAudioUnitStateDidAudioComponentInstanceNew = 4;
const NSEOperationState AVEAudioUnitStateDidConfigure = 5;
const NSEOperationState AVEAudioUnitStateDidAudioUnitUninitialize = 6;
const NSEOperationState AVEAudioUnitStateDidAudioUnitInitialize = 7;
const NSEOperationState AVEAudioUnitStateDidAudioOutputUnitStop = 8;
const NSEOperationState AVEAudioUnitStateDidAudioOutputUnitStart = 9;

NSErrorDomain const AVEAudioUnitErrorDomain = @"AVEAudioUnit";

static OSStatus AVEAudioUnitRenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);










@interface AVEAudioUnitElement ()

@property AudioUnit unit;
@property AudioUnitScope scope;
@property AudioUnitElement element;
@property AURenderCallbackStruct renderCallback;
@property NSError *error;

@end



@implementation AVEAudioUnitElement

@dynamic parent;
@dynamic delegates;

- (instancetype)initWithUnit:(AudioUnit)unit scope:(AudioUnitScope)scope element:(AudioUnitElement)element {
    self = super.init;
    if (self) {
        self.unit = unit;
        self.scope = scope;
        self.element = element;
        
        AURenderCallbackStruct renderCallback = {0};
        renderCallback.inputProc = AVEAudioUnitRenderCallback;
        renderCallback.inputProcRefCon = (__bridge void *)self;
        self.renderCallback = renderCallback;
    }
    return self;
}

#pragma mark - Helpers

- (void)getProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32 *)size {
    OSStatus status = AudioUnitGetProperty(self.unit, property, self.scope, self.element, data, size);
    if (status == noErr) {
        self.error = nil;
    } else {
        self.error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
}

- (void)setProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32)size {
    OSStatus status = AudioUnitSetProperty(self.unit, property, self.scope, self.element, data, size);
    if (status == noErr) {
        self.error = nil;
    } else {
        self.error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
}

- (void)getParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue *)value {
    OSStatus status = AudioUnitGetParameter(self.unit, parameter, self.scope, self.element, value);
    if (status == noErr) {
        self.error = nil;
    } else {
        self.error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
}

- (void)setParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue)value {
    OSStatus status = AudioUnitSetParameter(self.unit, parameter, self.scope, self.element, value, 0);
    if (status == noErr) {
        self.error = nil;
    } else {
        self.error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
}

#pragma mark - Properties

- (void)setKAudioUnitProperty_StreamFormat:(AudioStreamBasicDescription)streamFormat {
    [self setProperty:kAudioUnitProperty_StreamFormat data:&streamFormat size:sizeof(streamFormat)];
}

- (AudioStreamBasicDescription)kAudioUnitProperty_StreamFormat {
    AudioStreamBasicDescription streamFormat = {0};
    UInt32 size = sizeof(streamFormat);
    [self getProperty:kAudioUnitProperty_StreamFormat data:&streamFormat size:&size];
    return streamFormat;
}

- (void)setKAudioUnitProperty_ElementCount:(UInt32)elementCount {
    [self setProperty:kAudioUnitProperty_ElementCount data:&elementCount size:sizeof(elementCount)];
}

- (UInt32)kAudioUnitProperty_ElementCount {
    UInt32 elementCount = 0;
    UInt32 size = sizeof(elementCount);
    [self getProperty:kAudioUnitProperty_ElementCount data:&elementCount size:&size];
    return elementCount;
}

- (void)setKAudioUnitProperty_MaximumFramesPerSlice:(UInt32)maximumFramesPerSlice {
    [self setProperty:kAudioUnitProperty_MaximumFramesPerSlice data:&maximumFramesPerSlice size:sizeof(maximumFramesPerSlice)];
}

- (UInt32)kAudioUnitProperty_MaximumFramesPerSlice {
    UInt32 maximumFramesPerSlice = 0;
    UInt32 size = sizeof(maximumFramesPerSlice);
    [self getProperty:kAudioUnitProperty_MaximumFramesPerSlice data:&maximumFramesPerSlice size:&size];
    return maximumFramesPerSlice;
}

- (void)setKAudioUnitProperty_SetRenderCallback:(AURenderCallbackStruct)setRenderCallback {
    [self setProperty:kAudioUnitProperty_SetRenderCallback data:&setRenderCallback size:sizeof(setRenderCallback)];
}

- (AURenderCallbackStruct)kAudioUnitProperty_SetRenderCallback {
    AURenderCallbackStruct setRenderCallback = {0};
    UInt32 size = sizeof(setRenderCallback);
    [self getProperty:kAudioUnitProperty_SetRenderCallback data:&setRenderCallback size:&size];
    return setRenderCallback;
}

- (void)setKAudioUnitProperty_ElementName:(NSString *)elementName {
    CFStringRef cfElementName = (__bridge_retained CFStringRef)elementName;
    [self setProperty:kAudioUnitProperty_ElementName data:&cfElementName size:sizeof(cfElementName)];
}

- (NSString *)kAudioUnitProperty_ElementName {
    CFStringRef cfElementName = NULL;
    UInt32 size = sizeof(cfElementName);
    [self getProperty:kAudioUnitProperty_ElementName data:&cfElementName size:&size];
    NSString *elementName = (__bridge_transfer NSString *)cfElementName;
    return elementName;
}

- (void)setKAudioUnitProperty_ShouldAllocateBuffer:(UInt32)shouldAllocateBuffer {
    [self setProperty:kAudioUnitProperty_ShouldAllocateBuffer data:&shouldAllocateBuffer size:sizeof(shouldAllocateBuffer)];
}

- (UInt32)kAudioUnitProperty_ShouldAllocateBuffer {
    UInt32 shouldAllocateBuffer = 0;
    UInt32 size = sizeof(shouldAllocateBuffer);
    [self getProperty:kAudioUnitProperty_ShouldAllocateBuffer data:&shouldAllocateBuffer size:&size];
    return shouldAllocateBuffer;
}

- (void)setKAudioOutputUnitProperty_EnableIO:(UInt32)enableIO {
    [self setProperty:kAudioOutputUnitProperty_EnableIO data:&enableIO size:sizeof(enableIO)];
}

- (UInt32)kAudioOutputUnitProperty_EnableIO {
    UInt32 enableIO = 0;
    UInt32 size = sizeof(enableIO);
    [self getProperty:kAudioOutputUnitProperty_EnableIO data:&enableIO size:&size];
    return enableIO;
}

- (void)setKAudioOutputUnitProperty_SetInputCallback:(AURenderCallbackStruct)setInputCallback {
    [self setProperty:kAudioOutputUnitProperty_SetInputCallback data:&setInputCallback size:sizeof(setInputCallback)];
}

- (AURenderCallbackStruct)kAudioOutputUnitProperty_SetInputCallback {
    AURenderCallbackStruct setInputCallback = {0};
    UInt32 size = sizeof(setInputCallback);
    [self getProperty:kAudioOutputUnitProperty_SetInputCallback data:&setInputCallback size:&size];
    return setInputCallback;
}

@end










@interface AVEAudioUnit ()

@property AudioComponentDescription componentDescription;
@property AudioComponent component;
@property AudioUnit unit;
@property AVEAudioUnitElement *global;
@property NSMutableArray<AVEAudioUnitElement *> *inputs;
@property NSMutableArray<AVEAudioUnitElement *> *outputs;
@property AVEAudioSession *session;

@end



@implementation AVEAudioUnit

@dynamic delegates;

+ (instancetype)voiceProcessingIO {
    AudioComponentDescription description = {0};
    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    AVEAudioUnit *unit = [self.alloc initWithComponentDescription:description];
    return unit;
}

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription {
    self = super.init;
    if (self) {
        self.componentDescription = componentDescription;
        
        self.inputs = NSMutableArray.array;
        self.outputs = NSMutableArray.array;
        
        self.session = AVEAudioSession.shared;
        [self.session.delegates addObject:self];
    }
    return self;
}

- (NSError *)audioComponentFindNext {
    NSError *error = nil;
    self.component = AudioComponentFindNext(NULL, &_componentDescription);
    if (self.component) {
        [self updateState:AVEAudioUnitStateDidAudioComponentFindNext];
    } else {
        error = [NSError errorWithDomain:AVEAudioUnitErrorDomain code:AVEAudioUnitErrorNotFound userInfo:nil];
    }
    return error;
}

- (NSError *)audioComponentInstanceNew {
    NSError *error = nil;
    OSStatus status = AudioComponentInstanceNew(self.component, &_unit);
    if (status == noErr) {
        self.global = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Global element:0];
        [self.global.delegates addObject:self.delegates];
        
        AVEAudioUnitElement *input = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Input element:0];
        UInt32 inputElementCount = input.kAudioUnitProperty_ElementCount;
        if (input.error) {
            error = input.error;
        } else {
            [self.inputs removeAllObjects];
            for (AudioUnitElement element = 0; element < inputElementCount; element++) {
                input = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Input element:element];
                [input.delegates addObject:self.delegates];
                [self.inputs addObject:input];
            }

            AVEAudioUnitElement *output = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Output element:0];
            UInt32 outputElementCount = output.kAudioUnitProperty_ElementCount;
            if (output.error) {
                error = output.error;
            } else {
                [self.outputs removeAllObjects];
                for (AudioUnitElement element = 0; element < outputElementCount; element++) {
                    output = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Output element:element];
                    [output.delegates addObject:self.delegates];
                    [self.outputs addObject:output];
                }
                
                [self updateState:AVEAudioUnitStateDidAudioComponentInstanceNew];
            }
        }
    } else {
        error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
    return error;
}

//- (void)audioComponentInstanceDispose {
//    [self.errors removeAllObjects];
//    
//    OSStatus status = AudioComponentInstanceDispose(self.unit);
//    if (status == noErr) {
//        self.global = nil;
//        [self.inputs removeAllObjects];
//        [self.outputs removeAllObjects];
//        
//        [self updateState:AVEAudioUnitStateDidAudioComponentInstanceDispose];
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.errors addObject:error];
//    }
//}
//
//- (void)audioUnitInitialize {
//    [self.errors removeAllObjects];
//    
//    OSStatus status = AudioUnitInitialize(self.unit);
//    if (status == noErr) {
//        [self updateState:AVEAudioUnitStateDidAudioUnitInitialize];
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.errors addObject:error];
//    }
//}
//
//- (void)audioUnitUninitialize {
//    [self.errors removeAllObjects];
//    
//    OSStatus status = AudioUnitUninitialize(self.unit);
//    if (status == noErr) {
//        [self updateState:AVEAudioUnitStateDidAudioUnitUninitialize];
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.errors addObject:error];
//    }
//}
//
//- (void)audioOutputUnitStart {
//    [self.errors removeAllObjects];
//    
//    OSStatus status = AudioOutputUnitStart(self.unit);
//    if (status == noErr) {
//        [self updateState:AVEAudioUnitStateDidAudioOutputUnitStart];
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.errors addObject:error];
//    }
//}
//
//- (void)audioOutputUnitStop {
//    [self.errors removeAllObjects];
//    
//    OSStatus status = AudioOutputUnitStop(self.unit);
//    if (status == noErr) {
//        [self updateState:AVEAudioUnitStateDidAudioOutputUnitStop];
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.errors addObject:error];
//    }
//}
//
//#pragma mark - Audio session
//
//- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
//    HLPOperationState state = self.states.lastObject.unsignedIntegerValue;
//    if (state >= AVEAudioUnitStateDidAudioComponentFindNext) {
//        [self audioComponentFindNext];
//        if (self.errors.count == 0) {
//            if (state >= AVEAudioUnitStateDidAudioComponentInstanceNew) {
//                [self audioComponentInstanceDispose];
//                if (self.errors.count == 0) {
//                    [self audioComponentInstanceNew];
//                    if (self.errors.count == 0) {
//                        if (state >= AVEAudioUnitStateDidAudioUnitInitialize) {
//                            [self audioUnitInitialize];
//                            if (self.errors.count == 0) {
//                                if (state >= AVEAudioUnitStateDidAudioOutputUnitStart) {
//                                    [self audioOutputUnitStart];
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

@end










static OSStatus AVEAudioUnitRenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
//    AVEAudioUnitElement *element = (__bridge AVEAudioUnitElement *)inRefCon;
//    OSStatus status = [element.delegates AVEAudioUnitElementDidRender:ioActionFlags inTimeStamp:inTimeStamp inBusNumber:inBusNumber inNumberFrames:inNumberFrames ioData:ioData];
//    return status;
//
//    NSLog(@"bus - %u", inBusNumber);
    AVEAudioUnitElement *element = (__bridge AVEAudioUnitElement *)inRefCon;
    if (inBusNumber == 0) {
        AudioUnitRender(element.unit, ioActionFlags, inTimeStamp, 1, inNumberFrames, ioData);
    }
    return noErr;
}
