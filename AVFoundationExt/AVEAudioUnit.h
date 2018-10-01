//
//  AVEAudioUnit.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioUnitInstantiation, AVEAudioUnit, AVEAudioUnitElement;










@protocol AVEAudioUnitInstantiationDelegate <HLPOperationDelegate>

@end



@interface AVEAudioUnitInstantiation : HLPOperation <AVEAudioUnitInstantiationDelegate>

@property (readonly) AVEAudioUnit *parent;
@property (readonly) HLPArray<AVEAudioUnitInstantiationDelegate> *delegates;
@property (readonly) AudioComponentInstantiationOptions options;
@property (readonly) AudioUnit unit;
@property (readonly) HLPTick *tick;

- (instancetype)initWithOptions:(AudioComponentInstantiationOptions)options;

@end










@protocol AVEAudioUnitDelegate <AVEAudioUnitInstantiationDelegate>

@end



@interface AVEAudioUnit : HLPOperation <AVEAudioUnitDelegate>

@property AudioUnit unit;
@property NSMutableArray<AVEAudioUnitElement *> *inputs;
@property NSMutableArray<AVEAudioUnitElement *> *outputs;

@property (readonly) AudioComponentDescription componentDescription;
@property (readonly) AudioComponent component;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription;

- (AVEAudioUnitInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options;
- (AVEAudioUnitInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options completion:(HLPVoidBlock)completion;

@end










@protocol AVEAudioUnitElementDelegate <HLPOperationDelegate>

@end



@interface AVEAudioUnitElement : HLPOperation <AVEAudioUnitElementDelegate>

@property AudioStreamBasicDescription kAudioUnitProperty_StreamFormat;
@property UInt32 kAudioUnitProperty_ElementCount;
@property UInt32 kAudioUnitProperty_MaximumFramesPerSlice;
@property AURenderCallbackStruct kAudioUnitProperty_SetRenderCallback;
@property UInt32 kAudioOutputUnitProperty_EnableIO;
@property AURenderCallbackStruct kAudioOutputUnitProperty_SetInputCallback;

@property (readonly) AudioUnit unit;
@property (readonly) AudioUnitScope scope;
@property (readonly) AudioUnitElement element;

- (instancetype)initWithUnit:(AudioUnit)unit scope:(AudioUnitScope)scope element:(AudioUnitElement)element;

- (void)getProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32 *)size;
- (void)setProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32)size;

- (void)getParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue *)value;
- (void)setParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue)value;

@end










//componentType;
//OSType              componentSubType;
//OSType              componentManufacturer;

//@class AVEAudioUnitInstantiation, AVEAudioUnit, AVEAudioUnitElement;
//
//extern NSErrorDomain const AVEAudioUnitErrorDomain;
//
//NS_ERROR_ENUM(AVEAudioUnitErrorDomain) {
//    AVEAudioUnitErrorUnknown = 0,
//    AVEAudioUnitErrorNotFound = 1
//};
//
//
//
//
//
//
//
//
//
//
//@protocol AVEAudioUnitInstantiationDelegate <HLPOperationDelegate>
//
//@end
//
//
//
//@interface AVEAudioUnitInstantiation : HLPOperation <AVEAudioUnitInstantiationDelegate>
//
//@property (readonly) AVEAudioUnit *parent;
//@property (readonly) HLPArray<AVEAudioUnitInstantiationDelegate> *delegates;
//@property (readonly) AudioComponentInstantiationOptions options;
//@property (readonly) AudioComponent component;
//@property (readonly) AudioUnit unit;
//
//- (instancetype)initWithOptions:(AudioComponentInstantiationOptions)options;
//
//@end
//
//
//
//
//
//
//
//
//
//
//@protocol AVEAudioUnitDelegate <AVEAudioUnitInstantiationDelegate>
//
//@end
//
//
//
//@interface AVEAudioUnit : HLPOperation <AVEAudioUnitDelegate>
//
//@property OSType type;
//@property OSType subtype;
//@property OSType manufacturer;
//@property AudioComponent component;
//@property AudioUnit unit;
//
//@property (readonly) AVEAudioUnitElement *globalElement;
//@property (readonly) NSMutableArray<AVEAudioUnitElement *> *inputElements;
//@property (readonly) NSMutableArray<AVEAudioUnitElement *> *outputElements;
//
//- (AVEAudioUnitInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options;
//- (AVEAudioUnitInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options completion:(HLPVoidBlock)completion;
//
//@end
//
//
//
//
//
//
//
//
//
//
//@interface AVEAudioUnitElement : HLPObject
//
//@property UInt32 elementCount;
//@property Float64 sampleRate;
//
//@property (readonly) Float64 latency;
//
//@property (readonly) AudioUnitScope scope;
//@property (readonly) AudioUnitElement element;
//
//@property (weak, readonly) AVEAudioUnit *unit;
//
//- (instancetype)initWithUnit:(AVEAudioUnit *)unit scope:(AudioUnitScope)scope element:(AudioUnitElement)element;
//
//@end
//
//
//
//
//
//
//
//
//
//
////@class AVEAudioUnit;
////@class AVEAudioComponentInstantiation, AVEAudioComponent;
////
////
////
////
////
////
////
////
////
////
////@protocol AVEAudioUnitDelegate <HLPOperationDelegate>
////
////@end
////
////
////
////@interface AVEAudioUnit : HLPOperation <AVEAudioUnitDelegate>
////
////@property (readonly) AudioUnit unit;
////
////- (instancetype)initWithUnit:(AudioUnit)unit;
////
////- (NSData *)valueForProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element:(AudioUnitElement)element;
////- (void)setValue:(NSData *)value forProperty:(AudioUnitPropertyID)property scope:(AudioUnitScope)scope element:(AudioUnitElement)element;
////
////@end
////
////
////
////
////
////
////
////
////
////
////@protocol AVEAudioComponentInstantiationDelegate <HLPOperationDelegate>
////
////@end
////
////
////
////@interface AVEAudioComponentInstantiation : HLPOperation <AVEAudioComponentInstantiationDelegate>
////
////@property (readonly) AVEAudioComponent *parent;
////@property (readonly) HLPArray<AVEAudioComponentInstantiationDelegate> *delegates;
////@property (readonly) AudioComponentInstantiationOptions options;
////@property (readonly) AVEAudioUnit *unit;
////
////- (instancetype)initWithOptions:(AudioComponentInstantiationOptions)options;
////
////@end
////
////
////
////
////
////
////
////
////
////
////@protocol AVEAudioComponentDelegate <AVEAudioComponentInstantiationDelegate>
////
////@end
////
////
////
////@interface AVEAudioComponent : HLPOperationQueue <AVEAudioComponentDelegate>
////
////@property (readonly) AudioComponent component;
////
////- (instancetype)initWithComponent:(AudioComponent)component;
////
////- (AVEAudioComponentInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options;
////- (AVEAudioComponentInstantiation *)instantiateWithOptions:(AudioComponentInstantiationOptions)options completion:(HLPVoidBlock)completion;
////
////+ (NSArray<AVEAudioComponent *> *)componentsWithDescription:(AudioComponentDescription)description;
////
////@end
