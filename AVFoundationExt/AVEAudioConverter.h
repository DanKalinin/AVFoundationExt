//
//  AVEAudioConverter.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>
#import "AVEAudioSession.h"

@class AVEAudioConversion;
@class AVEAudioConverter;










@protocol AVEAudioConversionDelegate <NSEOperationDelegate>

@end



@interface AVEAudioConversion : NSEOperation <AVEAudioConversionDelegate>

@property (readonly) AVEAudioConverter *parent;
@property (readonly) HLPArray<AVEAudioConversionDelegate> *delegates;

@end










@protocol AVEAudioConverterDelegate <AVEAudioConversionDelegate>

@end



@interface AVEAudioConverter : NSEOperation <AVEAudioConverterDelegate, AVEAudioSessionDelegate>

extern const NSEOperationState AVEAudioConverterStateDidInitialize;
extern const NSEOperationState AVEAudioConverterStateDidConfigure;

extern NSErrorDomain const AVEAudioConverterErrorDomain;

NS_ERROR_ENUM(AVEAudioConverterErrorDomain) {
    AVEAudioConverterErrorUnknown = 0,
    AVEAudioConverterErrorConversionImpossible = 1
};

@property (readonly) HLPArray<AVEAudioConverterDelegate> *delegates;
@property (readonly) AVAudioFormat *fromFormat;
@property (readonly) AVAudioFormat *toFormat;
@property (readonly) AVAudioConverter *converter;
@property (readonly) AVEAudioSession *session;

- (instancetype)initFromFormat:(AVAudioFormat *)fromFormat toFormat:(AVAudioFormat *)toFormat;

- (void)initialize;
- (void)configure;

@end
