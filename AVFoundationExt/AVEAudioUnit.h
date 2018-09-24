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

- (NSData *)valueForProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element:(AudioUnitElement)element;
- (void)setValue:(NSData *)value forProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element:(AudioUnitElement)element;

@end










@protocol AVEAudioComponentInstantiationDelegate <HLPOperationDelegate>

@end



@interface AVEAudioComponentInstantiation : HLPOperation <AVEAudioComponentInstantiationDelegate>

@property (readonly) AVEAudioComponent *parent;
@property (readonly) HLPArray<AVEAudioComponentInstantiationDelegate> *delegates;
@property (readonly) AudioComponentInstantiationOptions options;
@property (readonly) AVEAudioUnit *unit;

- (instancetype)initWithOptions:(AudioComponentInstantiationOptions)options;

@end










@protocol AVEAudioComponentDelegate <AVEAudioComponentInstantiationDelegate>

@end



@interface AVEAudioComponent : HLPOperationQueue <AVEAudioComponentDelegate>

@property (readonly) AudioComponent component;

- (instancetype)initWithComponent:(AudioComponent)component;

- (AVEAudioComponentInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options;
- (AVEAudioComponentInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options completion:(HLPVoidBlock)completion;

+ (NSArray<AVEAudioComponent *> *)componentsWithDescription:(AudioComponentDescription)description;

@end
