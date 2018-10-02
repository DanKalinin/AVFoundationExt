//
//  AVEAudioConverter.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import "AVEAudioConverter.h"



@interface AVEAudioConverter ()

@property AVEAudioConverter *converter;

@end



@implementation AVEAudioConverter

- (instancetype)initFromFormat:(AVAudioFormat *)fromFormat toFormat:(AVAudioFormat *)toFormat {
    self = super.init;
    if (self) {
        self.converter = [AVEAudioConverter.alloc initFromFormat:fromFormat toFormat:toFormat];
    }
    return self;
}

@end
