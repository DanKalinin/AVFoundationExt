//
//  AVEAudioComponent.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/21/18.
//

#import "AVEAudioComponent.h"



@interface AVEAudioComponent ()

@property AudioComponent opaqueComponent;

@end



@implementation AVEAudioComponent

+ (NSArray<AVEAudioComponent *> *)componentsWithDescription:(AudioComponentDescription)description {
    NSMutableArray *components = NSMutableArray.array;
    
    AudioComponent opaqueComponent = NULL;
    while (YES) {
        opaqueComponent = AudioComponentFindNext(opaqueComponent, &description);
        if (opaqueComponent) {
            AVEAudioComponent *component = [AVEAudioComponent.alloc initWithOpaqueComponent:opaqueComponent];
            [components addObject:component];
        } else {
            break;
        }
    }
    
    return components;
}

- (instancetype)initWithOpaqueComponent:(AudioComponent)opaqueComponent {
    self = super.init;
    if (self) {
        self.opaqueComponent = opaqueComponent;
    }
    return self;
}

@end
