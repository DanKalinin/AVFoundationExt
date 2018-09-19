//
//  AVEVoiceManager.h
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import <Helpers/Helpers.h>
#import <AVFoundation/AVFoundation.h>

@class AVEVoiceManager;



@protocol AVEVoiceManagerDelegate <HLPOperationDelegate>

@end



@interface AVEVoiceManager : HLPOperation <AVEVoiceManagerDelegate>

@property (readonly) AudioComponent component;
@property (readonly) AudioUnit unit;


@end
