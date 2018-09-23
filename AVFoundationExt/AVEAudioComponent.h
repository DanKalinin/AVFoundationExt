//
//  AVEAudioComponent.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/21/18.
//

#import <AVFoundation/AVFoundation.h>
#import <Helpers/Helpers.h>

@class AVEAudioComponent;



@interface AVEAudioComponent : HLPObject

@property (readonly) AudioComponent opaqueComponent;

+ (NSArray<AVEAudioComponent *> *)componentsWithDescription:(AudioComponentDescription)description;

- (instancetype)initWithOpaqueComponent:(AudioComponent)opaqueComponent;

@end
