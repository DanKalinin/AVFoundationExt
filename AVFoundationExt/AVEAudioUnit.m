//
//  AVEAudioUnit.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import "AVEAudioUnit.h"










@interface AVEAudioUnit ()

@property AudioComponentDescription componentDescription;
@property AudioComponent component;
@property AudioUnit unit;
@property AVEAudioUnitElement *global;
@property NSMutableArray<AVEAudioUnitElement *> *inputs;
@property NSMutableArray<AVEAudioUnitElement *> *outputs;

@end



@implementation AVEAudioUnit

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription {
    self = super.init;
    if (self) {
        self.componentDescription = componentDescription;
        
        self.component = AudioComponentFindNext(NULL, &componentDescription);
        
        OSStatus status = AudioComponentInstanceNew(self.component, &_unit);
        if (status == noErr) {
            self.global = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Global element:0];
            
            self.inputs = NSMutableArray.array;
            AVEAudioUnitElement *input = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Input element:0];
            for (AudioUnitElement element = 0; element < input.kAudioUnitProperty_ElementCount; element++) {
                input = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Input element:element];
                [self.inputs addObject:input];
            }
            
            self.outputs = NSMutableArray.array;
            AVEAudioUnitElement *output = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Output element:0];
            for (AudioUnitElement element = 0; element < output.kAudioUnitProperty_ElementCount; element++) {
                output = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Output element:element];
                [self.outputs addObject:output];
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
            [self.errors addObject:error];
        }
    }
    return self;
}

@end










@interface AVEAudioUnitElement ()

@property AudioUnit unit;
@property AudioUnitScope scope;
@property AudioUnitElement element;

@end



@implementation AVEAudioUnitElement

- (instancetype)initWithUnit:(AudioUnit)unit scope:(AudioUnitScope)scope element:(AudioUnitElement)element {
    self = super.init;
    if (self) {
        self.unit = unit;
        self.scope = scope;
        self.element = element;
    }
    return self;
}

#pragma mark - Helpers

- (void)getProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32 *)size {
    OSStatus status = AudioUnitGetProperty(self.unit, property, self.scope, self.element, data, size);
    if (status == noErr) {
    } else {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        [self.errors addObject:error];
    }
}

- (void)setProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32)size {
    OSStatus status = AudioUnitSetProperty(self.unit, property, self.scope, self.element, data, size);
    if (status == noErr) {
    } else {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        [self.errors addObject:error];
    }
}

- (void)getParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue *)value {
    OSStatus status = AudioUnitGetParameter(self.unit, parameter, self.scope, self.element, value);
    if (status == noErr) {
    } else {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        [self.errors addObject:error];
    }
}

- (void)setParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue)value {
    OSStatus status = AudioUnitSetParameter(self.unit, parameter, self.scope, self.element, value, 0);
    if (status == noErr) {
    } else {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        [self.errors addObject:error];
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

//NSErrorDomain const AVEAudioUnitErrorDomain = @"AVEAudioUnit";
//
//
//
//
//
//
//
//
//
//
//@interface AVEAudioUnitInstantiation ()
//
//@property AudioComponentInstantiationOptions options;
//@property AudioComponent component;
//@property AudioUnit unit;
//
//@end
//
//
//
//@implementation AVEAudioUnitInstantiation
//
//@dynamic parent;
//@dynamic delegates;
//
//- (instancetype)initWithOptions:(AudioComponentInstantiationOptions)options {
//    self = super.init;
//    if (self) {
//        self.options = options;
//    }
//    return self;
//}
//
//- (void)main {
//    [self updateState:HLPOperationStateDidBegin];
//
//    AudioComponentDescription description = {0};
//    description.componentType = self.parent.type;
//    description.componentSubType = self.parent.subtype;
//    description.componentManufacturer = self.parent.manufacturer;
//
//    self.component = AudioComponentFindNext(NULL, &description);
//    if (self.component) {
//        dispatch_group_enter(self.group);
//        AudioComponentInstantiate(self.component, self.options, ^(AudioUnit unit, OSStatus status) {
//            if (status == noErr) {
//                self.unit = unit;
//
//                self.parent.component = self.component;
//                self.parent.unit = self.unit;
//            } else {
//                NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//                [self.errors addObject:error];
//            }
//            dispatch_group_leave(self.group);
//        });
//        dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
//    } else {
//        NSError *error = [NSError errorWithDomain:AVEAudioUnitErrorDomain code:AVEAudioUnitErrorNotFound userInfo:nil];
//        [self.errors addObject:error];
//    }
//
//    [self updateState:HLPOperationStateDidEnd];
//}
//
//@end
//
//
//
//
//
//
//
//
//
//
//@interface AVEAudioUnit ()
//
//@property AVEAudioUnitElement *globalElement;
//@property NSMutableArray<AVEAudioUnitElement *> *inputElements;
//@property NSMutableArray<AVEAudioUnitElement *> *outputElements;
//
//@end
//
//
//
//@implementation AVEAudioUnit
//
//- (instancetype)init {
//    self = super.init;
//    if (self) {
//        self.manufacturer = kAudioUnitManufacturer_Apple;
//
//        self.globalElement = [AVEAudioUnitElement.alloc initWithUnit:self scope:kAudioUnitScope_Global element:0];
//        self.inputElements = NSMutableArray.array;
//        self.outputElements = NSMutableArray.array;
//    }
//    return self;
//}
//
//- (AVEAudioUnitInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options {
//    AVEAudioUnitInstantiation *instantiation = [AVEAudioUnitInstantiation.alloc initWithOptions:options];
//    [self addOperation:instantiation];
//    return instantiation;
//}
//
//- (AVEAudioUnitInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options completion:(HLPVoidBlock)completion {
//    AVEAudioUnitInstantiation *instantiation = [self instantiateWithOptions:options];
//    instantiation.completionBlock = completion;
//    return instantiation;
//}
//
//@end
//
//
//
//
//
//
//
//
//
//
//@interface AVEAudioUnitElement ()
//
//@property AudioUnitScope scope;
//@property AudioUnitElement element;
//
//@property (weak) AVEAudioUnit *unit;
//
//@end
//
//
//
//@implementation AVEAudioUnitElement
//
//- (instancetype)initWithUnit:(AVEAudioUnit *)unit scope:(AudioUnitScope)scope element:(AudioUnitElement)element {
//    self = super.init;
//    if (self) {
//        self.unit = unit;
//        self.scope = scope;
//        self.element = element;
//    }
//    return self;
//}
//
//#pragma mark - Accessors
//
//- (void)setElementCount:(UInt32)elementCount {
//    OSStatus status = AudioUnitSetProperty(self.unit.unit, kAudioUnitProperty_ElementCount, self.scope, self.element, &elementCount, sizeof(elementCount));
//    if (status == noErr) {
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.unit.errors addObject:error];
//    }
//}
//
//- (UInt32)elementCount {
//    UInt32 elementCount = 0.0;
//    UInt32 size = sizeof(elementCount);
//    OSStatus status = AudioUnitGetProperty(self.unit.unit, kAudioUnitProperty_ElementCount, self.scope, self.scope, &elementCount, &size);
//    if (status == noErr) {
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.unit.errors addObject:error];
//    }
//    return elementCount;
//}
//
//- (void)setSampleRate:(Float64)sampleRate {
//    OSStatus status = AudioUnitSetProperty(self.unit.unit, kAudioUnitProperty_SampleRate, self.scope, self.element, &sampleRate, sizeof(sampleRate));
//    if (status == noErr) {
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.unit.errors addObject:error];
//    }
//}
//
//- (Float64)sampleRate {
//    Float64 sampleRate = 0.0;
//    UInt32 size = sizeof(sampleRate);
//    OSStatus status = AudioUnitGetProperty(self.unit.unit, kAudioUnitProperty_SampleRate, self.scope, self.scope, &sampleRate, &size);
//    if (status == noErr) {
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.unit.errors addObject:error];
//    }
//    return sampleRate;
//}
//
//- (Float64)latency {
//    Float64 latency = 0.0;
//    UInt32 size = sizeof(latency);
//    OSStatus status = AudioUnitGetProperty(self.unit.unit, kAudioUnitProperty_Latency, self.scope, self.scope, &latency, &size);
//    if (status == noErr) {
//    } else {
//        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
//        [self.unit.errors addObject:error];
//    }
//    return latency;
//}
//
//@end
//
//
//
//
//
//
//
//
//
//
////@interface AVEAudioUnit ()
////
////@property AudioUnit unit;
////
////@end
////
////
////
////@implementation AVEAudioUnit
////
////- (instancetype)initWithUnit:(AudioUnit)unit {
////    self = super.init;
////    if (self) {
////        self.unit = unit;
////    }
////    return self;
////}
////
////- (NSData *)valueForProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element:(AudioUnitElement)element {
////    NSData *value = nil;
////    UInt32 length = 0;
////    OSStatus status = AudioUnitGetPropertyInfo(self.unit, property, scope, element, &length, NULL);
////    if (status == noErr) {
////        void *bytes = malloc(length);
////        status = AudioUnitGetProperty(self.unit, property, scope, element, bytes, &length);
////        if (status == noErr) {
////            value = [NSData dataWithBytes:bytes length:length];
////        } else {
////            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
////            [self.errors addObject:error];
////        }
////        free(bytes);
////    } else {
////        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
////        [self.errors addObject:error];
////    }
////    return value;
////}
////
////- (void)setValue:(NSData *)value forProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element:(AudioUnitElement)element {
////    OSStatus status = AudioUnitSetProperty(self.unit, property, scope, element, value.bytes, (UInt32)value.length);
////    if (status == noErr) {
////    } else {
////        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
////        [self.errors addObject:error];
////    }
////}
////
////@end
////
////
////
////
////
////
////
////
////
////
////@interface AVEAudioComponentInstantiation ()
////
////@property AudioComponentInstantiationOptions options;
////@property AVEAudioUnit *unit;
////
////@end
////
////
////
////@implementation AVEAudioComponentInstantiation
////
////@dynamic parent;
////@dynamic delegates;
////
////- (instancetype)initWithOptions:(AudioComponentInstantiationOptions)options {
////    self = super.init;
////    if (self) {
////        self.options = options;
////    }
////    return self;
////}
////
////- (void)main {
////    [self updateState:HLPOperationStateDidBegin];
////
////    dispatch_group_enter(self.group);
////    AudioComponentInstantiate(self.parent.component, self.options, ^(AudioComponentInstance opaqueUnit, OSStatus status) {
////        if (status == noErr) {
////            self.unit = [AVEAudioUnit.alloc initWithUnit:opaqueUnit];
////        } else {
////            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
////            [self.errors addObject:error];
////        }
////        dispatch_group_leave(self.group);
////    });
////    dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
////
////    [self updateState:HLPOperationStateDidEnd];
////}
////
////@end
////
////
////
////
////
////
////
////
////
////
////@interface AVEAudioComponent ()
////
////@property AudioComponent component;
////
////@end
////
////
////
////@implementation AVEAudioComponent
////
////- (instancetype)initWithComponent:(AudioComponent)component {
////    self = super.init;
////    if (self) {
////        self.component = component;
////    }
////    return self;
////}
////
////- (AVEAudioComponentInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options {
////    AVEAudioComponentInstantiation *instantiation = [AVEAudioComponentInstantiation.alloc initWithOptions:options];
////    [self addOperation:instantiation];
////    return instantiation;
////}
////
////- (AVEAudioComponentInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options completion:(HLPVoidBlock)completion {
////    AVEAudioComponentInstantiation *instantiation = [self instantiateWithOptions:options];
////    instantiation.completionBlock = completion;
////    return instantiation;
////}
////
////+ (NSArray<AVEAudioComponent *> *)componentsWithDescription:(AudioComponentDescription)description {
////    NSMutableArray *components = NSMutableArray.array;
////
////    AudioComponent opaqueComponent = NULL;
////    while (YES) {
////        opaqueComponent = AudioComponentFindNext(opaqueComponent, &description);
////        if (opaqueComponent) {
////            AVEAudioComponent *component = [AVEAudioComponent.alloc initWithComponent:opaqueComponent];
////            [components addObject:component];
////        } else {
////            break;
////        }
////    }
////
////    return components;
////}
////
////@end
