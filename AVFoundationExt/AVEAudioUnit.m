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

@property AVEAudioUnit *unit;

@end



@implementation AVEAudioComponentInstantiation

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

@end
