//
//  AVEAudioUnit.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioUnit;
@class AVEAudioComponentInstantiation, AVEAudioComponent;










@protocol AVEAudioUnitDelegate <HLPOperationDelegate>

@end



@interface AVEAudioUnit : HLPOperation <AVEAudioUnitDelegate>

@property (readonly) AudioUnit unit;

- (instancetype)initWithUnit:(AudioUnit)unit;

@end










@protocol AVEAudioComponentInstantiationDelegate <HLPOperationDelegate>

@end



@interface AVEAudioComponentInstantiation : HLPOperation <AVEAudioComponentInstantiationDelegate>

@property (readonly) AVEAudioUnit *unit;

@end










@protocol AVEAudioComponentDelegate <AVEAudioComponentInstantiationDelegate>

@end



@interface AVEAudioComponent : HLPOperationQueue <AVEAudioComponentDelegate>

@property (readonly) AudioComponent component;

- (instancetype)initWithComponent:(AudioComponent)component;

+ (NSArray<AVEAudioComponent *> *)componentsWithDescription:(AudioComponentDescription)description;

@end
