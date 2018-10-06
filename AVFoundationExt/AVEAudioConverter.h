//
//  AVEAudioConverter.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>
#import "AVEAudioSession.h"

@class AVEAudioConversion, AVEAudioConverter;

extern const HLPOperationState AVEAudioConverterDidStart;
extern const HLPOperationState AVEAudioConverterDidStop;

extern NSErrorDomain const AVEAudioConverterErrorDomain;

NS_ERROR_ENUM(AVEAudioConverterErrorDomain) {
    AVEAudioConverterErrorUnknown = 0,
    AVEAudioConverterErrorConversionImpossible = 1
};










@protocol AVEAudioConversionDelegate <HLPOperationDelegate>

@end



@interface AVEAudioConversion : HLPOperation <AVEAudioConversionDelegate>

@property (readonly) AVEAudioConverter *parent;
@property (readonly) HLPArray<AVEAudioConversionDelegate> *delegates;

@end










@protocol AVEAudioConverterDelegate <AVEAudioConversionDelegate>

@end



@interface AVEAudioConverter : HLPOperation <AVEAudioConverterDelegate, AVEAudioSessionDelegate>

@property (readonly) HLPArray<AVEAudioConverterDelegate> *delegates;
@property (readonly) AVAudioFormat *fromFormat;
@property (readonly) AVAudioFormat *toFormat;
@property (readonly) AVAudioConverter *converter;
@property (readonly) AVEAudioSession *session;

- (instancetype)initFromFormat:(AVAudioFormat *)fromFormat toFormat:(AVAudioFormat *)toFormat;

- (void)start;
- (void)stop;

@end
