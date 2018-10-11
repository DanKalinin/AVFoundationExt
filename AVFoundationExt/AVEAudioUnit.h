//
//  AVEAudioUnit.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/20/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>
#import "AVEAudioSession.h"

@class AVEAudioUnitElement, AVEAudioUnit;

extern const HLPOperationState NSEAudioUnitStateDidAudioComponentFindNext;
extern const HLPOperationState NSEAudioUnitStateDidAudioComponentInstanceDispose;
extern const HLPOperationState NSEAudioUnitStateDidAudioComponentInstanceNew;
extern const HLPOperationState NSEAudioUnitStateDidAudioUnitUninitialize;
extern const HLPOperationState NSEAudioUnitStateDidAudioUnitInitialize;
extern const HLPOperationState NSEAudioUnitStateDidAudioOutputUnitStop;
extern const HLPOperationState NSEAudioUnitStateDidAudioOutputUnitStart;

extern NSErrorDomain const AVEAudioUnitErrorDomain;

NS_ERROR_ENUM(AVEAudioUnitErrorDomain) {
    AVEAudioUnitErrorUnknown = 0,
    AVEAudioUnitErrorNotFound = 1
};










@protocol AVEAudioUnitElementDelegate <NSEOperationDelegate>

@optional
- (OSStatus)AVEAudioUnitElementDidRender:(AudioUnitRenderActionFlags *)ioActionFlags inTimeStamp:(const AudioTimeStamp *)inTimeStamp inBusNumber:(UInt32)inBusNumber inNumberFrames:(UInt32)inNumberFrames ioData:(AudioBufferList *)ioData;

@end



@interface AVEAudioUnitElement : NSEOperation <AVEAudioUnitElementDelegate>

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

@end



@interface AVEAudioUnit : NSEOperation <AVEAudioUnitDelegate, AVEAudioSessionDelegate>

@property (readonly) HLPArray<AVEAudioUnitDelegate> *delegates;
@property (readonly) AudioComponentDescription componentDescription;
@property (readonly) AudioComponent component;
@property (readonly) AudioUnit unit;
@property (readonly) AVEAudioUnitElement *global;
@property (readonly) NSMutableArray<AVEAudioUnitElement *> *inputs;
@property (readonly) NSMutableArray<AVEAudioUnitElement *> *outputs;
@property (readonly) AVEAudioSession *session;

+ (instancetype)voiceProcessingIO;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription;

- (NSError *)audioComponentFindNext;

- (NSError *)audioComponentInstanceNew;
- (NSError *)audioComponentInstanceDispose;

- (NSError *)audioUnitInitialize;
- (NSError *)audioUnitUninitialize;

- (NSError *)audioOutputUnitStart;
- (NSError *)audioOutputUnitStop;

- (NSError *)configure;

@end
