//
//  AVEAudioUnit.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import "AVEAudioUnit.h"










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
                [input.delegates addObject:self.delegates];
                [self.inputs addObject:input];
            }
            
            self.outputs = NSMutableArray.array;
            AVEAudioUnitElement *output = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Output element:0];
            for (AudioUnitElement element = 0; element < output.kAudioUnitProperty_ElementCount; element++) {
                output = [AVEAudioUnitElement.alloc initWithUnit:self.unit scope:kAudioUnitScope_Output element:element];
                [output.delegates addObject:self.delegates];
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
