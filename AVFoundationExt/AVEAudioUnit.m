//
//  AVEAudioUnit.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import "AVEAudioUnit.h"



@interface AVEAudioUnit ()

@property AudioComponentDescription componentDescription;

@end



@implementation AVEAudioUnit

@dynamic delegates;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription {
    self = super.init;
    if (self) {
        self.componentDescription = componentDescription;
    }
    return self;
}

@end
