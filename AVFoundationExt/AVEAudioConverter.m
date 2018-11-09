//
//  AVEAudioConverter.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import "AVEAudioConverter.h"










@interface AVEAudioConverterMediaServicesWereResetInfo ()

@property NSError *error;

@end



@implementation AVEAudioConverterMediaServicesWereResetInfo

- (instancetype)initWithError:(NSError *)error {
    self = super.init;
    if (self) {
        self.error = error;
    }
    return self;
}

@end










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
@property AVEAudioConverterMediaServicesWereResetInfo *mediaServicesWereResetInfo;

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

- (void)convertToBuffer:(AVAudioBuffer *)toBuffer fromBuffer:(AVAudioBuffer *)fromBuffer {
    NSError *error = nil;
    AVAudioConverterOutputStatus status = [self.converter convertToBuffer:toBuffer error:&error withInputFromBlock:^AVAudioBuffer *(AVAudioPacketCount inNumberOfPackets, AVAudioConverterInputStatus *outStatus) {
        *outStatus = AVAudioConverterInputStatus_HaveData;
        return fromBuffer;
    }];
    NSError.threadError = error;
}

#pragma mark - Audio session

- (void)AVEAudioSessionMediaServicesWereReset:(AVEAudioSession *)audioSession {
    NSEOperationState state = self.state;
    if (state >= AVEAudioConverterStateDidInitialize) {
        [self initialize];
        if (NSError.threadError) {
        } else {
            if (state >= AVEAudioConverterStateDidConfigure) {
                [self configure];
            }
        }
    }
    
    self.mediaServicesWereResetInfo = [AVEAudioConverterMediaServicesWereResetInfo.alloc initWithError:NSError.threadError];
}

@end
