//
//  AVEAudioUnit.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import "AVEAudioUnit.h"










@interface AVEAudioUnit ()

@property AudioUnit unit;

@end



@implementation AVEAudioUnit

- (instancetype)initWithUnit:(AudioUnit)unit {
    self = super.init;
    if (self) {
        self.unit = unit;
    }
    return self;
}

- (NSData *)valueForProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element:(AudioUnitElement)element {
    NSData *value = nil;
    UInt32 length = 0;
    OSStatus status = AudioUnitGetPropertyInfo(self.unit, property, scope, element, &length, NULL);
    if (status == noErr) {
        void *bytes = malloc(length);
        status = AudioUnitGetProperty(self.unit, property, scope, element, bytes, &length);
        if (status == noErr) {
            value = [NSData dataWithBytes:bytes length:length];
        } else {
            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
            [self.errors addObject:error];
        }
        free(bytes);
    } else {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        [self.errors addObject:error];
    }
    return value;
}

- (void)setValue:(NSData *)value forProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element:(AudioUnitElement)element {
    OSStatus status = AudioUnitSetProperty(self.unit, property, scope, element, value.bytes, (UInt32)value.length);
    if (status == noErr) {
    } else {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
        [self.errors addObject:error];
    }
}

@end










@interface AVEAudioComponentInstantiation ()

@property AudioComponentInstantiationOptions options;
@property AVEAudioUnit *unit;

@end



@implementation AVEAudioComponentInstantiation

@dynamic parent;
@dynamic delegates;

- (instancetype)initWithOptions:(AudioComponentInstantiationOptions)options {
    self = super.init;
    if (self) {
        self.options = options;
    }
    return self;
}

- (void)main {
    [self updateState:HLPOperationStateDidBegin];
    
    dispatch_group_enter(self.group);
    AudioComponentInstantiate(self.parent.component, self.options, ^(AudioComponentInstance opaqueUnit, OSStatus status) {
        if (status == noErr) {
            self.unit = [AVEAudioUnit.alloc initWithUnit:opaqueUnit];
        } else {
            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
            [self.errors addObject:error];
        }
        dispatch_group_leave(self.group);
    });
    dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER);
    
    [self updateState:HLPOperationStateDidEnd];
}

@end










@interface AVEAudioComponent ()

@property AudioComponent component;

@end



@implementation AVEAudioComponent

- (instancetype)initWithComponent:(AudioComponent)component {
    self = super.init;
    if (self) {
        self.component = component;
    }
    return self;
}

- (AVEAudioComponentInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options {
    AVEAudioComponentInstantiation *instantiation = [AVEAudioComponentInstantiation.alloc initWithOptions:options];
    [self addOperation:instantiation];
    return instantiation;
}

- (AVEAudioComponentInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options completion:(HLPVoidBlock)completion {
    AVEAudioComponentInstantiation *instantiation = [self instantiateWithOptions:options];
    instantiation.completionBlock = completion;
    return instantiation;
}

+ (NSArray<AVEAudioComponent *> *)componentsWithDescription:(AudioComponentDescription)description {
    NSMutableArray *components = NSMutableArray.array;
    
    AudioComponent opaqueComponent = NULL;
    while (YES) {
        opaqueComponent = AudioComponentFindNext(opaqueComponent, &description);
        if (opaqueComponent) {
            AVEAudioComponent *component = [AVEAudioComponent.alloc initWithComponent:opaqueComponent];
            [components addObject:component];
        } else {
            break;
        }
    }
    
    return components;
}

@end
