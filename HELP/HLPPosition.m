//
//  HLPPosition.m
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import "HLPPosition.h"

@implementation HLPPosition

static HLPPosition *hLPPosition = nil;

+ (id)sharedHLPPositionManager {
    static HLPPosition *sharedHLPPosition = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHLPPosition = [[self alloc] init];
    });
    return sharedHLPPosition;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}



@end

