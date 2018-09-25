//
//  AVEAudioUnitOutput.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/25/18.
//

#import "AVEAudioUnitOutput.h"



@interface AVEAudioUnitOutput ()

@end



@implementation AVEAudioUnitOutput

- (instancetype)init {
    self = super.init;
    if (self) {
        self.componentDescription->componentType = kAudioUnitType_Output;
    }
    return self;
}

@end
