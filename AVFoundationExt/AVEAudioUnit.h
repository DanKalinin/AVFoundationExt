//
//  AVEAudioUnit.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>
#import "AVEAudioSession.h"

@class AVEAudioUnitElementDidRenderInfo;
@class AVEAudioUnitMediaServicesWereResetInfo;
@class AVEAudioUnitElement;
@class AVEAudioUnit;










@interface AVEAudioUnitElementDidRenderInfo : HLPObject

@property NSError *error;

@property (readonly) AudioUnitRenderActionFlags *ioActionFlags;
@property (readonly) const AudioTimeStamp *inTimeStamp;
@property (readonly) UInt32 inBusNumber;
@property (readonly) UInt32 inNumberFrames;
@property (readonly) AudioBufferList *ioData;

- (instancetype)initWithIOActionFlags:(AudioUnitRenderActionFlags *)ioActionFlags inTimeStamp:(const AudioTimeStamp *)inTimeStamp inBusNumber:(UInt32)inBusNumber inNumberFrames:(UInt32)inNumberFrames ioData:(AudioBufferList *)ioData;

@end










@interface AVEAudioUnitMediaServicesWereResetInfo : HLPObject

@property (readonly) NSError *error;

- (instancetype)initWithError:(NSError *)error;

@end










@protocol AVEAudioUnitElementDelegate <NSEOperationDelegate>

@optional
- (void)AVEAudioUnitElementDidRender:(AVEAudioUnitElement *)element;

@end



@interface AVEAudioUnitElement : NSEOperation <AVEAudioUnitElementDelegate>

extern OSStatus AVEAudioUnitElementRenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);

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
@property (readonly) AVEAudioUnitElementDidRenderInfo *didRenderInfo;

- (instancetype)initWithUnit:(AudioUnit)unit scope:(AudioUnitScope)scope element:(AudioUnitElement)element;

- (void)getProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32 *)size;
- (void)setProperty:(AudioUnitPropertyID)property data:(void *)data size:(UInt32)size;

- (void)getParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue *)value;
- (void)setParameter:(AudioUnitParameterID)parameter value:(AudioUnitParameterValue)value;

@end










@protocol AVEAudioUnitDelegate <AVEAudioUnitElementDelegate>

@end



@interface AVEAudioUnit : NSEOperation <AVEAudioUnitDelegate, AVEAudioSessionDelegate>

extern const NSEOperationState AVEAudioUnitStateDidAudioComponentFindNext;
extern const NSEOperationState AVEAudioUnitStateDidAudioComponentInstanceDispose;
extern const NSEOperationState AVEAudioUnitStateDidAudioComponentInstanceNew;
extern const NSEOperationState AVEAudioUnitStateDidConfigure;
extern const NSEOperationState AVEAudioUnitStateDidAudioUnitUninitialize;
extern const NSEOperationState AVEAudioUnitStateDidAudioUnitInitialize;
extern const NSEOperationState AVEAudioUnitStateDidAudioOutputUnitStop;
extern const NSEOperationState AVEAudioUnitStateDidAudioOutputUnitStart;

extern NSErrorDomain const AVEAudioUnitErrorDomain;

NS_ERROR_ENUM(AVEAudioUnitErrorDomain) {
    AVEAudioUnitErrorUnknown = 0,
    AVEAudioUnitErrorNotFound = 1
};

@property (readonly) HLPArray<AVEAudioUnitDelegate> *delegates;
@property (readonly) AudioComponentDescription componentDescription;
@property (readonly) AudioComponent component;
@property (readonly) AudioUnit unit;
@property (readonly) AVEAudioUnitElement *global;
@property (readonly) NSMutableArray<AVEAudioUnitElement *> *inputs;
@property (readonly) NSMutableArray<AVEAudioUnitElement *> *outputs;
@property (readonly) AVEAudioSession *session;
@property (readonly) AVEAudioUnitMediaServicesWereResetInfo *mediaServicesWereResetInfo;

+ (instancetype)voiceProcessingIO;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription;

- (void)audioComponentFindNext;

- (void)audioComponentInstanceNew;
- (void)audioComponentInstanceDispose;

- (void)configure;

- (void)audioUnitInitialize;
- (void)audioUnitUninitialize;

- (void)audioOutputUnitStart;
- (void)audioOutputUnitStop;

- (void)audioUnitRender:(AudioUnitRenderActionFlags *)ioActionFlags inTimeStamp:(const AudioTimeStamp *)inTimeStamp inOutputBusNumber:(UInt32)inOutputBusNumber inNumberFrames:(UInt32)inNumberFrames ioData:(AudioBufferList *)ioData;

@end
