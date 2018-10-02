//
//  AVEAudioUnit.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioUnit, AVEAudioUnitElement;










@protocol AVEAudioUnitDelegate <HLPOperationDelegate>

@end



@interface AVEAudioUnit : HLPOperation <AVEAudioUnitDelegate>

@property (readonly) AudioComponentDescription componentDescription;
@property (readonly) AudioComponent component;
@property (readonly) AudioUnit unit;
@property (readonly) AVEAudioUnitElement *global;
@property (readonly) NSMutableArray<AVEAudioUnitElement *> *inputs;
@property (readonly) NSMutableArray<AVEAudioUnitElement *> *outputs;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription;

@end










@protocol AVEAudioUnitElementDelegate <HLPOperationDelegate>

@end



@interface AVEAudioUnitElement : HLPOperation <AVEAudioUnitElementDelegate>

@property AudioStreamBasicDescription kAudioUnitProperty_StreamFormat;
@property UInt32 kAudioUnitProperty_ElementCount;
@property UInt32 kAudioUnitProperty_MaximumFramesPerSlice;
@property AURenderCallbackStruct kAudioUnitProperty_SetRenderCallback;
@property NSString *kAudioUnitProperty_ElementName;
@property UInt32 kAudioUnitProperty_ShouldAllocateBuffer;
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
