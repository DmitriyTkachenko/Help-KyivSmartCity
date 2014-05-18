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
#import <MapKit/MapKit.h>

@interface HLPPosition : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * street;
@property (nonatomic, strong) NSString * house;
@property (nonatomic) CLLocationCoordinate2D coordinates;

//-(void)findCurrentLocation;

+ (instancetype)sharedHLPPositionManager;

@end
