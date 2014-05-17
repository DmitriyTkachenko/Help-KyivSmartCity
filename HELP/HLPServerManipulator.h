//
//  HLPServerManipulator.h
//  HELP
//
//  Created by Vladislav on 5/17/14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLPServerManipulator : NSObject <NSURLConnectionDelegate>

-(void)registerRequestWithName:(NSString *)name Phone:(NSString *)phoneNumber;

@end
