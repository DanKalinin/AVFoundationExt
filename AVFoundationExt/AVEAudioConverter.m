//
//  AVEAudioConverter.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import "AVEAudioConverter.h"










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

const NSEOperationState AVEAudioConverterStateDidInitialize = 2;
const NSEOperationState AVEAudioConverterStateDidConfigure = 3;

NSErrorDomain const AVEAudioConverterErrorDomain = @"AVEAudioConverter";

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

- (void)initialize {
    self.converter = [AVAudioConverter.alloc initFromFormat:self.fromFormat toFormat:self.toFormat];
    if (self.converter) {
        NSError.threadError = nil;
        self.state = AVEAudioConverterStateDidInitialize;
    } else {
        NSError.threadError = [NSError errorWithDomain:AVEAudioConverterErrorDomain code:AVEAudioConverterErrorConversionImpossible userInfo:nil];
    }
}

- (void)configure {
    NSError.threadError = nil;
    self.state = AVEAudioConverterStateDidConfigure;
}

#pragma mark - Audio session

- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
//    if (self.errors.count == 0) {
//        NSEOperationState state = self.state;
//        if (state >= AVEAudioConverterStateDidInitialize) {
//            NSError *error = [self initialize];
//            if (error) {
//                [self.errors addObject:error];
//            } else {
//                if (state >= AVEAudioConverterStateDidConfigure) {
//                    error = [self configure];
//                    if (error) {
//                        [self.errors addObject:error];
//                    }
//                }
//            }
//        }
//    }
}

@end
