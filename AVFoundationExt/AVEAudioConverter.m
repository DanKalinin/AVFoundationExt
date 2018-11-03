//
//  AVEAudioConverter.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import "AVEAudioConverter.h"

const NSEOperationState AVEAudioConverterStateDidInitialize = 2;
const NSEOperationState AVEAudioConverterStateDidConfigure = 3;

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

- (NSError *)initialize {
    NSError *error = nil;
    self.converter = [AVAudioConverter.alloc initFromFormat:self.fromFormat toFormat:self.toFormat];
    if (self.converter) {
        [self updateState:AVEAudioConverterStateDidInitialize];
    } else {
        error = [NSError errorWithDomain:AVEAudioConverterErrorDomain code:AVEAudioConverterErrorConversionImpossible userInfo:nil];
    }
    return error;
}

- (NSError *)configure {
    [self updateState:AVEAudioConverterStateDidConfigure];
    return nil;
}

#pragma mark - Audio session

- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
    if (self.errors.count == 0) {
        NSEOperationState state = self.state;
        if (state >= AVEAudioConverterStateDidInitialize) {
            NSError *error = [self initialize];
            if (error) {
                [self.errors addObject:error];
            } else {
                if (state >= AVEAudioConverterStateDidConfigure) {
                    error = [self configure];
                    if (error) {
                        [self.errors addObject:error];
                    }
                }
            }
        }
    }
}

@end
