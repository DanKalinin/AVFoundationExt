//
//  AVEAudioUnit.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioUnit;



@protocol AVEAudioUnitDelegate <HLPOperationDelegate>

@end



@interface AVEAudioUnit : HLPOperation <AVEAudioUnitDelegate>

@property (readonly) HLPArray<AVEAudioUnitDelegate> *delegates;
@property (readonly) AudioComponentDescription componentDescription;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription;

@end
