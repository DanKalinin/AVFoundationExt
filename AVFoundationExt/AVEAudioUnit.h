//
//  AVEAudioUnit.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioUnitElement, AVEAudioUnit;

extern const HLPOperationState AVEAudioUnitStateDidInitialize;
extern const HLPOperationState AVEAudioUnitStateDidUninitialize;

extern NSErrorDomain const AVEAudioUnitErrorDomain;

NS_ERROR_ENUM(AVEAudioUnitErrorDomain) {
    AVEAudioUnitErrorUnknown = 0,
    AVEAudioUnitErrorNotFound = 1
};










@protocol AVEAudioUnitElementDelegate <HLPOperationDelegate>

@optional
- (OSStatus)AVEAudioUnitElementDidRender:(AudioUnitRenderActionFlags *)ioActionFlags inTimeStamp:(const AudioTimeStamp *)inTimeStamp inBusNumber:(UInt32)inBusNumber inNumberFrames:(UInt32)inNumberFrames ioData:(AudioBufferList *)ioData;

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

@property (readonly) AVEAudioUnit *parent;
@property (readonly) HLPArray<AVEAudioUnitElementDelegate> *delegates;
@property (readonly) AudioUnit unit;
@property (readonly) AudioUnitScope scope;
@property (readonly) AudioUnitElement element;
@property (readonly) AURenderCallbackStruct renderCallback;

- (instancetype)initWithUnit:(AudioUnit)unit scope:(AudioUnitScope)scope element:(AudioUnitElement)element;

- (void)getProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32 *)size;
- (void)setProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32)size;

- (void)getParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue *)value;
- (void)setParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue)value;

@end










@protocol AVEAudioUnitDelegate <AVEAudioUnitElementDelegate>

@optional
- (void)AVEAudioUnitDidUpdateState:(AVEAudioUnit *)unit;

- (void)AVEAudioUnitDidBegin:(AVEAudioUnit *)unit;
- (void)AVEAudioUnitDidEnd:(AVEAudioUnit *)unit;
- (void)AVEAudioUnitDidInitialize:(AVEAudioUnit *)unit;
- (void)AVEAudioUnitDidUninitialize:(AVEAudioUnit *)unit;

@end



@interface AVEAudioUnit : HLPOperation <AVEAudioUnitDelegate>

@property (readonly) HLPArray<AVEAudioUnitDelegate> *delegates;
@property (readonly) AudioComponentDescription componentDescription;
@property (readonly) AudioComponent component;
@property (readonly) AudioUnit unit;
@property (readonly) AVEAudioUnitElement *global;
@property (readonly) NSMutableArray<AVEAudioUnitElement *> *inputs;
@property (readonly) NSMutableArray<AVEAudioUnitElement *> *outputs;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription;

- (void)initialize;
- (void)uninitialize;

@end
