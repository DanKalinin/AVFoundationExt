//
//  AVEAudioConverter.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import "AVEAudioConverter.h"

const HLPOperationState AVEAudioConverterDidInit = 0;
const HLPOperationState AVEAudioConverterDidStart = 1;
const HLPOperationState AVEAudioConverterDidStop = 2;

NSErrorDomain const AVEAudioConverterErrorDomain = @"AVEAudioConverter";










@interface AVEAudioConversion ()

@end



@implementation AVEAudioConversion

@dynamic parent;
@dynamic delegates;

@end










@interface AVEAudioConverter ()

@property AVAudioFormat *fromFormat;
@property AVAudioFormat *toFormat;
@property AVAudioConverter *converter;
@property AVEAudioSession *session;

@end



@implementation AVEAudioConverter

@dynamic delegates;

- (instancetype)initFromFormat:(AVAudioFormat *)fromFormat toFormat:(AVAudioFormat *)toFormat {
    self = super.init;
    if (self) {
        self.fromFormat = fromFormat;
        self.toFormat = toFormat;
        
        self.session = AVEAudioSession.shared;
        [self.session.delegates addObject:self];
    }
    return self;
}

- (void)start {
    [self.states removeAllObjects];
    [self.errors removeAllObjects];
    
    self.converter = [AVAudioConverter.alloc initFromFormat:self.fromFormat toFormat:self.toFormat];
    if (self.converter) {
        self.state = AVEAudioConverterDidStart;
        [self updateState:AVEAudioConverterDidStart];
    } else {
        NSError *error = [NSError errorWithDomain:AVEAudioConverterErrorDomain code:AVEAudioConverterErrorConversionImpossible userInfo:nil];
        [self.errors addObject:error];
    }
}

- (void)stop {
    [self.states removeAllObjects];
    
    self.converter = nil;
    
    self.state = AVEAudioConverterDidInit;
    [self updateState:AVEAudioConverterDidStop];
}

#pragma mark - Audio session

- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
    HLPOperationState state = self.state;
    if (state >= AVEAudioConverterDidStart) {
        [self start];
    }
}

@end
