//
//  AVEAudioConverter.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/2/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>



@protocol AVEAudioConverterDelegate <HLPOperationDelegate>

@end



@interface AVEAudioConverter : HLPOperation <AVEAudioConverterDelegate>

@property (readonly) AVEAudioConverter *converter;

- (instancetype)initFromFormat:(AVAudioFormat *)fromFormat toFormat:(AVAudioFormat *)toFormat;

@end
