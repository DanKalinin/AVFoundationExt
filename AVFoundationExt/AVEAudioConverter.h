//
//  AVEAudioConverter.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioConversion, AVEAudioConverter;










@protocol AVEAudioConversionDelegate <HLPOperationDelegate>

@end



@interface AVEAudioConversion : HLPOperation <AVEAudioConversionDelegate>

@property (readonly) AVEAudioConverter *parent;
@property (readonly) HLPArray<AVEAudioConversionDelegate> *delegates;

@end










@protocol AVEAudioConverterDelegate <AVEAudioConversionDelegate>

@end



@interface AVEAudioConverter : HLPOperation <AVEAudioConverterDelegate>

@property (readonly) HLPArray<AVEAudioConverterDelegate> *delegates;
@property (readonly) AVEAudioConverter *converter;

- (instancetype)initFromFormat:(AVAudioFormat *)fromFormat toFormat:(AVAudioFormat *)toFormat;

@end
