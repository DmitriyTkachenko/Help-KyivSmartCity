//
//  HLPPosition.h
//  HELP
//
//  Created by WildSpirit on 17.05.14.
//  Copyright (c) 2014 WildSpirit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface HLPPosition : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSString * address;
@property (nonatomic) CLLocationCoordinate2D coordinates;

-(void)findCurrentLocation;

-(void)registerView:(UIViewController *)viewC;

+ (instancetype)sharedHLPPositionManager;

@end
