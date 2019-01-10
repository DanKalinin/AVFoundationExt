//
//  AVEAudioConverter.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import <AVFoundation/AVFoundation.h>
#import <FoundationExt/FoundationExt.h>
#import "AVEAudioSession.h"

@class AVEAudioConverterMediaServicesWereResetInfo;
@class AVEAudioConversion;
@class AVEAudioConverter;










@interface AVEAudioConverterMediaServicesWereResetInfo : HLPObject

@property (readonly) NSError *error;

- (instancetype)initWithError:(NSError *)error;

@end










@protocol AVEAudioConversionDelegate <NSEOperationDelegate>

@end



@interface AVEAudioConversion : NSEOperation <AVEAudioConversionDelegate>

@property (readonly) AVEAudioConverter *parent;
@property (readonly) NSOrderedSet<AVEAudioConversionDelegate> *delegates;

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

@property (readonly) NSEOrderedSet<AVEAudioConverterDelegate> *delegates;
@property (readonly) AVAudioFormat *fromFormat;
@property (readonly) AVAudioFormat *toFormat;
@property (readonly) AVAudioConverter *converter;
@property (readonly) AVEAudioSession *session;
@property (readonly) AVEAudioConverterMediaServicesWereResetInfo *mediaServicesWereResetInfo;

- (instancetype)initFromFormat:(AVAudioFormat *)fromFormat toFormat:(AVAudioFormat *)toFormat;

- (void)initialize;
- (void)configure;

- (void)convertToBuffer:(AVAudioBuffer *)toBuffer fromBuffer:(AVAudioBuffer *)fromBuffer;

@end
