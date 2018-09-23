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
    AudioComponentInstantiate(self.parent.component, self.options, ^(AudioComponentInstance unit, OSStatus status) {
        
    });
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

@end
