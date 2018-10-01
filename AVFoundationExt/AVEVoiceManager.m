//
//  AVEVoiceManager.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 9/15/18.
//

#import "AVEVoiceManager.h"



@interface AVEVoiceManager ()

@property AVEAudioSession *session;
@property AVEAudioUnit *unit;

@end



@implementation AVEVoiceManager

+ (instancetype)shared {
    static AVEVoiceManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = self.new;
    });
    return shared;
}

- (instancetype)init {
    self = super.init;
    if (self) {
        self.session = AVEAudioSession.shared;
        
        AudioComponentDescription description = {0};
        description.componentType = kAudioUnitType_Output;
        description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
        description.componentManufacturer = kAudioUnitManufacturer_Apple;

        self.unit = [AVEAudioUnit.alloc initWithComponentDescription:description];
        
        AVEAudioUnitInstantiation *instantiation = [self.unit instantiateWithOptions:kAudioComponentInstantiation_LoadOutOfProcess];
        instantiation.delegates.operationQueue = nil;
        [instantiation waitUntilFinished];
        
//        self.unit = AVEAudioUnitVoiceProcessingIO.new;
        
//        AVEAudioUnitInstantiation *instantiation = [self.unit instantiateWithOptions:kAudioComponentInstantiation_LoadOutOfProcess];
//        instantiation.delegates.operationQueue = nil;
//        [instantiation waitUntilFinished];
        
//        self.unit.globalElement.sampleRate = 44100.0;
//        NSLog(@"unit - %@", self.unit.globalElement.elementName);
//        NSLog(@"errors - %@", self.unit.errors);
        
        
        
        
//        AudioComponentDescription description = {0};
//        description.componentType = kAudioUnitType_Output;
//        description.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
//        description.componentManufacturer = kAudioUnitManufacturer_Apple;
        
//        NSArray *components = [AVEAudioComponent componentsWithDescription:description];
//        NSLog(@"components - %@", components);
//        
//        AVEAudioComponentInstantiation *instantiation = [components.firstObject instantiateWithOptions:kAudioComponentInstantiation_LoadOutOfProcess];
//        instantiation.delegates.operationQueue = nil;
//        [instantiation waitUntilFinished];
//        NSLog(@"unit - %@", instantiation.unit);
        
//        NSData *enableIO = [instantiation.unit valueForProperty:kAudioOutputUnitProperty_EnableIO scope:kAudioUnitScope_Output element:0];
//        NSLog(@"enableIO - %@", enableIO);
//        NSLog(@"errors - %@", instantiation.unit.errors);
        
//        NSLog(@"components - %@", [AVEAudioComponent componentsWithDescription:description]);
        
//        AVEAudioComponent *component = [AVEAudioComponent componentsWithDescription:description].firstObject;
//        NSLog(@"name - %@", component.name);
        
//        NSError *error = nil;
//        self.audioUnit = [AUAudioUnit.alloc initWithComponentDescription:description error:&error];
//        if (error) {
//            [self.errors addObject:error];
//        } else {
//            NSLog(@"class - %@", self.audioUnit.parameterTree.children);
//        }
        
        // componentName = Apple: AUVoiceIO
        // componentVersion = 65792
        // audioUnitName = AUVoiceIO
        // manufacturerName = Apple
        // renderResourcesAllocated = YES - after - allocateRenderResourcesAndReturnError:
        // maximumFramesToRender = 1156
        // inputBusses = 2, outputBusses = 2
    }
    return self;
}

@end
