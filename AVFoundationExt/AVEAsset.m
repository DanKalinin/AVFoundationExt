//
//  AVEAsset.m
//  AVFoundationExt
//
//  Created by Dan Kalinin on 10/1/18.
//

#import "AVEAsset.h"



@interface AVEAsset ()

@property AVAsset *asset;

@end



@implementation AVEAsset

@dynamic delegates;

- (instancetype)initWithAsset:(AVAsset *)asset {
    self = super.init;
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (void)start {
//    AVAssetDurationDidChangeNotification
//    AVAssetContainsFragmentsDidChangeNotification
//    AVAssetWasDefragmentedNotification
//    AVAssetChapterMetadataGroupsDidChangeNotification
//    AVAssetMediaSelectionGroupsDidChangeNotification
    
    [self updateState:HLPOperationStateDidBegin];
}

- (void)cancel {
    [self.notificationCenter removeObserver:self];
    
    [self updateState:HLPOperationStateDidEnd];
}

@end
